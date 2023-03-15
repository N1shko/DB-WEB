import os

from access import *
from flask import *
from db_context_manager import *
from db_work import *
from sql_provider import *


blueprint_order = Blueprint('bp_order', __name__, template_folder='templates', static_folder='static')

provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))


@blueprint_order.route('/', methods=['GET', 'POST'])
@group_required
def order_index():
    #clear_basket()
    summary = 0
    db_config = current_app.config['dbconfig']
    if request.method == 'GET':
        sql = provider.get('all_items.sql')
        items = select_dict(db_config, sql)
        print(items)
        basket_items = session.get('basket', {})
        for i in basket_items:
            summary = summary + int(basket_items[i]['blank_price']) * int(basket_items[i]['prod_count'])
        session['sum'] = summary
        return render_template('basket_order_list.html', items=items, basket=basket_items, sum=summary)
    else:
        if request.form.get('action1') is None:
            price = request.form.get('price')
            amount = request.form.get('add_amount')
            Nomen_blank_id = request.form['Nomen_blank_id']
            print(request.form)
            #sql = provider.get('all_items.sql')
            sql = provider.get('select_item.sql', Nomen_blank_id=Nomen_blank_id)
            items = select_dict(db_config, sql)
            add_to_basket(Nomen_blank_id, items, price, amount)
            return redirect(url_for('bp_order.order_index'))
        else:
            delete_item(request.form.get('id'))
            return redirect(url_for('bp_order.order_index'))

def add_to_basket(Nomen_blank_id, items: dict, price, amount):
    # item_description = [item for item in items if str(item['prod_id']) == str(prod_id)]
    # print('Item_description before = ', item_description)
    # item_description = item_description[0]
    curr_basket = session.get('basket', {})
   # print(type(session['basket']))
    if Nomen_blank_id in curr_basket:
        if (price == curr_basket[Nomen_blank_id]['blank_price']):
            curr_basket[Nomen_blank_id]['prod_count'] = int(curr_basket[Nomen_blank_id]['prod_count'])+int(amount)
        else:
            curr_basket[Nomen_blank_id] = {
                'blank_name': items[0]['blank_name'],
                'blank_price': price,
                'prod_count': amount,
            }
            session['basket'] = curr_basket

            session.permanent = True
    else:
        curr_basket[Nomen_blank_id] = {
            'blank_name': items[0]['blank_name'],
            'blank_price': price,
            'prod_count': amount
        }
        session['basket'] = curr_basket
        session.permanent = True
    print(curr_basket)
    return True


@blueprint_order.route('/save_order', methods=['GET', 'POST'])
@group_required
def save_order():
    user_id = session.get('user_id')
    current_basket = session.get('basket', {})
    order_id = save_order_with_list(current_app.config['dbconfig'], user_id, current_basket)
    if order_id:
        session.pop('basket')
        return render_template('order_created.html', order_id=order_id)
    else:
        return 'something went wrong'


def save_order_with_list(dbconfig: dict, user_id: int, current_basket):
    with DBContextManager(dbconfig) as cursor:
        if cursor is None:
            raise ValueError('Cursor not created')
        print("created")
        print(user_id)
        summ = session.get('sum')
        _sql1 = provider.get('insert_order.sql', user_id=user_id, all=summ)
        result1 = cursor.execute(_sql1)
        if result1 == 1:
            _sql2 = provider.get('select_order_id.sql', user_id=user_id)
            cursor.execute(_sql2)
            order_id = cursor.fetchall()[0][0]
            print('order_id= ', order_id)
            if order_id:
                for key in current_basket:
                    print(current_basket[key])
                    print(key, current_basket[key]['prod_count'])
                    new_b_amount = current_basket[key]['prod_count']
                    new_b_price = current_basket[key]['blank_price']
                    _sql3=provider.get('insert_order_list.sql', cons_id=order_id, b_id=key, b_amount=new_b_amount, b_price=new_b_price)
                    print(_sql3)
                    cursor.execute(_sql3)
                return order_id


@blueprint_order.route('/clear_basket')
@group_required
def clear_basket():
    print(session)
    if 'basket' in session:
        del session['basket']
    return redirect(url_for('bp_order.order_index'))


@group_required
def delete_item(a):
    print(session)
    if 'basket' in session:
        del session['basket'][a]
    return redirect(url_for('bp_order.order_index'))



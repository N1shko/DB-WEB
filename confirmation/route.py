import os

from access import *
from flask import *
from db_context_manager import *
from db_work import *
from sql_provider import *


blueprint_confirm = Blueprint('bp_confirm', __name__, template_folder='templates', static_folder='static')

provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))


@blueprint_confirm.route('/check', methods=['GET', 'POST'])
@group_required
def order_check():

    columns = ["ID накладной", "Дата создания", "Сумма накладной", "ID поставщика", "Доступные действия"]
    if request.method == 'GET':
        sql = provider.get('unchecked_cons.sql')
        product_result = select_dict(current_app.config['dbconfig'], sql)
        if product_result:
            return render_template('consigment_view.html', schema=columns, result=product_result)
        else:
            return render_template('empty_cons.html')
    else:
        cn_id = request.form['cn_id']
        if request.form.get('action1') is not None:
                with DBContextManager(current_app.config['dbconfig']) as cursor:
                    if cursor is None:
                        raise ValueError('Cursor not created')
                    resa = call_proc(current_app.config['dbconfig'], 'cons_insert', cn_id)
                    sql3 = provider.get('cons_update.sql', cn_id=cn_id)
                    cursor.execute(sql3)
        elif request.form.get('action') is not None:
            columns = ["ID строки", "ID накладной", "Цена за единицу", "Количество", "ID детали"]
            sql4 = provider.get('select_cons.sql', cons_id=cn_id)
            product_result, schema = select(current_app.config['dbconfig'], sql4)
            return render_template('cons_view.html', schema=columns, result=product_result, number=cn_id)
        else:

            with DBContextManager(current_app.config['dbconfig']) as cursor:
                if cursor is None:
                    raise ValueError('Cursor not created')
                _sql = provider.get('line_delete.sql', cn_id=cn_id)
                cursor.execute(_sql)
                _sql = provider.get('cons_delete.sql', cn_id=cn_id)
                cursor.execute(_sql)
        sql = provider.get('unchecked_cons.sql')
        product_result = select_dict(current_app.config['dbconfig'], sql)
        if product_result:
            return render_template('consigment_view.html', schema=columns, result=product_result)
        else:
            return render_template('empty_cons.html')
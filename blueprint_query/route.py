import os

from flask import Blueprint, request, render_template, current_app, session
from db_work import *
from sql_provider import SQLProvider
from access import *


blueprint_query = Blueprint('bp_query', __name__, template_folder='templates')

provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))


@blueprint_query.route('/query', methods=['GET', 'POST'])
def query():
    if session.get('user_group') == "external":
        return render_template('ext_request_menu.html')
    else:
        return render_template('queries_menu.html')


@blueprint_query.route('/storage', methods=['GET', 'POST'])
@group_required
def storage():
    columns = ["ID", "Дата последнего обновления", "Количество", "Цена", "ID по номенклатуре"]
    if request.method == 'GET':
        _sql = provider.get('storage.sql')
        product_result, schema = select(current_app.config['dbconfig'], _sql)
        return render_template('db_result.html', schema=columns, result=product_result )


# @blueprint_query.route('/base1', methods=['GET', 'POST'])
# @group_required
# def base1():
#     columns = ["Месяц поставки", "ID по номенклатуре", "Количество"]
#     if request.method == 'GET':
#         return render_template('queries1.html')
#     else:
#         input_year = request.form.get('input_year')
#         if input_year:
#             _sql = provider.get('queries1.sql', input_year=input_year)
#             product_result, schema = select(current_app.config['dbconfig'], _sql)
#             return render_template('db_result.html', schema=columns, result=product_result )
#         else:
#             return "Repeat input"


@blueprint_query.route('cons_data', methods=['GET', 'POST'])
def cons_data():
    if session.get('user_group') == "external":
        columns = ["Номер строки", "Цена", "Количество", "ID заготовки"]
        if request.method == 'GET':
            user_id = session.get('user_id')
            _sql = provider.get('queries2_1.sql', supplier_id=user_id)
            product_result = select_dict(current_app.config['dbconfig'], _sql)
            print(product_result[10]['cn_id'])
            return render_template('queries2_1.html', result=product_result)
        else:
            input_id = request.form.get('input_id')
            user_id = session.get('user_id')
            _sql = provider.get('queries2_2.sql', cn_id=input_id, supplier_id=user_id)
            product_result, schema = select(current_app.config['dbconfig'], _sql)
            return render_template('db_result.html', schema=columns, result=product_result)
    else:
        columns = ["Номер строки накладной", "Цена", "Количество", "ID заготовки", "ID поставщика"]
        if request.method == 'GET':
            return render_template('queries2.html')
        else:
            input_id = request.form.get('input_id')
            _sql = provider.get('queries2.sql', input_id=input_id)
            product_result, schema = select(current_app.config['dbconfig'], _sql)
            if product_result:
                return render_template('db_result.html', schema=columns, result=product_result)
            else:
                return render_template('youfool.html')



@blueprint_query.route('/sup_cons', methods=['GET', 'POST'])
def sup_cons():
    columns = ["ID накладной", "Дата поставки", "Сумма накладной", "ID поставщика", "Имя поставщика",
                "Город поставщика", "Дата заключения договора", "Телефон поставщика"]
    if session.get('user_group') == "external":
        input_id = session.get('user_id')
        _sql = provider.get('queries3.sql', input_id=input_id)
        product_result, schema = select(current_app.config['dbconfig'], _sql)
        return render_template('db_result.html', schema=columns, result=product_result)
    else:
        if request.method == 'GET':
            return render_template('queries3.html')
        else:
            input_id = request.form.get('input_id')
            _sql = provider.get('queries3.sql', input_id=input_id)
            product_result, schema = select(current_app.config['dbconfig'], _sql)
            if product_result:
                return render_template('db_result.html', schema=columns, result=product_result)
            else:
                return render_template('youfool.html')


@blueprint_query.route('/sup_date', methods=['GET', 'POST'])
@group_required
def sup_date():
    columns = ["ID поставщика", "Имя поставщика", "Город поставщика", "Дата заключения договора", "Телефон поставщика"]
    if request.method == 'GET':
        return render_template('queries4.html')
    else:
        if request.form.get('action') is None:
            input_date = request.form.get('input_date') + '-01'
            input_date1 = request.form.get('input_date1') + '-01'
            _sql = provider.get('queries4.sql', input_date=input_date, input_date1=input_date1)
            product_result, schema = select(current_app.config['dbconfig'], _sql)
            if product_result:
                return render_template('db_result.html', schema=columns, result=product_result)
            else:
                return render_template('youfool.html')
        else:
            _sql = provider.get('queries4_2.sql')
            product_result, schema = select(current_app.config['dbconfig'], _sql)
            return render_template('db_result.html', schema=columns, result=product_result)

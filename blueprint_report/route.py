import os.path
from flask import Blueprint, request, render_template, current_app, redirect, url_for
from access import login_required, group_required

from db_work import select, call_proc
from sql_provider import *

from access import *

blueprint_report = Blueprint('bp_report', __name__, template_folder='templates')
provider = SQLProvider(os.path.join(os.path.dirname(__file__), 'sql'))
report_list = [{"rep_name": "Отчет о поставках за месяц", "rep_id": "1"},
               {"rep_name": "Отчет о выручке за месяц", "rep_id": "2"}]
report_url = {report_list[0]["rep_id"]: {'create_rep': 'bp_report.create_rep1', 'view_rep': 'bp_report.view_rep1'},
              report_list[1]["rep_id"]: {'create_rep': 'bp_report.create_rep2', 'view_rep': 'bp_report.view_rep2'}}


@blueprint_report.route('/', methods=['GET', 'POST'])
@login_required
def start_report():
    if request.method == 'GET':
        temp = 0
        if session.get('user_group') == "manager":
            temp = 1
        return render_template('menu_report.html', report_list=report_list, manager=temp)
    else:
        rep_id = request.form.get('rep_id')
        if request.form.get('create_rep'):
            url_rep = report_url[rep_id]['create_rep']
        else:
            url_rep = report_url[rep_id]['view_rep']
        return redirect(url_for(url_rep))


@blueprint_report.route('/create_rep1', methods=['GET', 'POST'])
@group_required
def create_rep1():
    if request.method == 'GET':
        return render_template('report_create.html')
    else:
        rep_date = request.form.get('input_date').split("-")
        rep_year = rep_date[0]
        rep_month = rep_date[1]
        sql_check = provider.get('report1_res.sql', input_year=rep_year, input_month=rep_month)
        product_result, schema = select(current_app.config['dbconfig'], sql_check)
        if len(product_result) == 0:
            print("it is none")
            res = call_proc(current_app.config['dbconfig'], 'year_report', rep_year, rep_month)
            return render_template('report_created.html', title=rep_date, theme="поставках")
        else:
            return render_template('report_already_exists.html', title=rep_date, theme="поставках")


@blueprint_report.route('/view_rep1', methods=['GET', 'POST'])
@group_required
def view_rep1():
    columns = ["ID заготовки", "Имя заготовки", "Количество поставленных заготовок"]
    if request.method == 'GET':
        return render_template('view_report1.html')
    else:
        rep_date = request.form.get('input_date').split("-")
        rep_year = rep_date[0]
        rep_month = rep_date[1]
        _sql = provider.get('report1_res.sql', input_year=rep_year, input_month=rep_month)
        product_result, schema = select(current_app.config['dbconfig'], _sql)
        if (len(product_result) == 0):
            return render_template('report_doesnt_exist.html', title=rep_date, theme='поставках')
        else:
            return render_template('report_view.html', schema=columns, result=product_result, title=rep_date, theme='поставках')


@blueprint_report.route('/create_rep2', methods=['GET', 'POST'])
@group_required
def create_rep2():
    if request.method == 'GET':
        return render_template('report_create.html')
    else:
        rep_date = request.form.get('input_date').split("-")
        rep_year = rep_date[0]
        rep_month = rep_date[1]
        sql_check = provider.get('report2_res.sql', input_year=rep_year, input_month=rep_month)
        product_result, schema = select(current_app.config['dbconfig'], sql_check)
        if len(product_result) == 0:
            print("it is none")
            res = call_proc(current_app.config['dbconfig'], 'year_report1', rep_year, rep_month)
            return render_template('report_created.html', title=rep_date, theme="поставках")
        else:
            return render_template('report_already_exists.html', title=rep_date, theme="выручке")


@blueprint_report.route('/view_rep2', methods=['GET', 'POST'])
@group_required
def view_rep2():
    columns = ["ID заготовки", "Имя заготовки", "Суммарная цена заготовок"]
    if request.method == 'GET':
        return render_template('view_report1.html')
    else:
        rep_date = request.form.get('input_date').split("-")
        rep_year = rep_date[0]
        rep_month = rep_date[1]
        _sql = provider.get('report2_res.sql', input_year=rep_year, input_month=rep_month)
        product_result, schema = select(current_app.config['dbconfig'], _sql)
        if (len(product_result) == 0):
            return render_template('report_doesnt_exist.html', title=rep_date, theme='выручке')
        else:
            return render_template('report_view.html', schema=columns, result=product_result, title=rep_date, theme='выручке')

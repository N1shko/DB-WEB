import json

from flask import Flask, render_template, session, redirect, url_for
from auth.route import blueprint_auth
from blueprint_query.route import blueprint_query
from blueprint_report.route import blueprint_report
from basket.route import blueprint_order
from confirmation.route import blueprint_confirm
from access import login_required


app = Flask(__name__)
app.secret_key = 'SuperKey'

app.register_blueprint(blueprint_auth, url_prefix='/auth')
app.register_blueprint(blueprint_query, url_prefix='/zaproses')
app.register_blueprint(blueprint_report, url_prefix='/report')
app.register_blueprint(blueprint_order, url_prefix='/order')
app.register_blueprint(blueprint_confirm, url_prefix='/confirm')
app.config['dbconfig'] = json.load(open('data_files/dbconfig.json'))
app.config['access_config'] = json.load(open('data_files/access.json'))


@app.route('/', methods=['GET', 'POST'])
@login_required
def menu_choice():
    #if 'user_id' in session:
    if session.get('user_group') == None or session.get('user_group') == "external":
        session['user_group'] = "external"
        return render_template('external_user_menu.html')
    elif session.get('user_group') == "manager":
        return render_template('manager_menu.html')
    else:
        return render_template('director_menu.html')
   

@app.route('/exit')
@login_required
def exit_func():
    session.clear()
    return render_template("Goodbye_moonman.html")


if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5001)

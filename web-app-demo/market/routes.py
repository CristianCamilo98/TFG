from market import app
from flask import render_template, redirect, url_for, flash, jsonify
from market.models import Item, User, UserSchema, ItemSchema 
from market.forms import RegisterForm, LoginForm
from market import db
from flask_login import login_user, logout_user, login_required
from market.weather_api import get_meteo_for_locality
from flask import request
from market  import api
from flask_restful import Resource
from market import simplebackend
import requests


@app.route('/')
@app.route('/home')
def home_page(): 
    return render_template('home.html')

@app.route('/market')
@login_required
def market_page():
    city = request.args.get('city', default = "madrid", type = str)
    weather=get_meteo_for_locality(city)
    items = Item.query.all()
    for item in items:
        item.price = float(item.price)*(weather/24)
    return render_template('market.html', items=items, weather=weather)



@app.route('/register', methods=['GET', 'POST'])
def register_page():
    form = RegisterForm()
    if form.validate_on_submit():   # With this function we will know if the client has press submit button
        user_to_create = User(username=form.username.data, email_address=form.email_address.data, password=form.password1.data)
        db.session.add(user_to_create)
        db.session.commit()
        return redirect(url_for('market_page'))

    if form.errors != {}: # If there are not errors from the validations
        print(form.errors)
        for err_msg in form.errors.values():
            flash(f'There was an error with creating a user: {err_msg}', category='danger')

    return render_template('register.html', form=form)

@app.route('/login', methods=['GET', 'POST'])
def login_page():
    form = LoginForm()
    if form.validate_on_submit():
        attempted_user = User.query.filter_by(username=form.username.data).first()
        if attempted_user and attempted_user.check_password_correction(attempted_password=form.password.data):
            login_user(attempted_user)
            flash(f'Sucess! You are logged in as: {attempted_user.username}',category='success')
            return redirect(url_for('market_page'))
        else:
            flash(f'Username and password are not match! Please try again', categoru='danger')

    return render_template('login.html', form=form)

@app.route('/logout')
def logout_page():
    logout_user()
    flash(f"You have been logged out!", category='info')
    return redirect(url_for('home_page'))
    
@app.route('/call-backend')
def call_backend():
    if simplebackend:
        endpoint = simplebackend
    else:
        endpoint = "http://simple-backend"


    r = requests.get(endpoint)

    if r.status_code == 200:
        return jsonify(r.json())
    else:
        return "simplebackend did not respond", r.status_code



####### APIS ##########


names = {
        "cristian": {"age": 23, "gender": "male"},
         "rebeca" : {"age": 23, "gender": "female"}
        }

class user_api(Resource):
    def get(self,name):
        if name != "all":
            user_schema = UserSchema()
            user_db = User.query.filter_by(username=name).first()
            output = user_schema.dump(user_db)
        else:
            user_schema = UserSchema(many=True)
            user_db = User.query.all()
            output = user_schema.dump(user_db)

            
        return output   

    def post(self):
        return {"data": "Post"}


class item_api(Resource):
    def get(self,item):
        item_schema = ItemSchema()
        item_db = Item.query.filter_by(name=item).first()
        output = item_schema.dump(item_db)
        return output   

    def post(self):
        return {"data": "Post"}


api.add_resource(user_api,"/api/user/<string:name>")
api.add_resource(item_api,"/api/item/<string:item>")

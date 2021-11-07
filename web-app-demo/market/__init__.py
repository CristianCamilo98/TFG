from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from flask_login import LoginManager
from flask_restful import Api, Resource
from flask_marshmallow import Marshmallow
import os
# LOADING ENVIRONMENT VARIABLES
api_key = os.getenv('OPENWEATHERMAP_API_KEY')
#
app = Flask(__name__)

## We add some configuration to the flask app in this case the database associated
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://flask_pre:securepassword@mysql/flask_pre_models'
app.config['SECRET_KEY'] = '506b2d9c135deeec805b7c59'
db = SQLAlchemy(app)
bcrypt = Bcrypt(app)
login_manager = LoginManager(app)
api = Api(app)
ma = Marshmallow(app)

login_manager.login_view = "login_page"
login_manager.login_message_category = "info"
from market import routes

from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField
from wtforms.validators import Length,EqualTo, Email, DataRequired, ValidationError
from market.models import User

class RegisterForm(FlaskForm):
    username = StringField(label='User name:', validators=[Length(min=2, max=30), DataRequired()])
    email_address = StringField(label='Email Address:',validators=[Email(), DataRequired()])
    password1 = PasswordField(label='Password:', validators=[Length(min=6), DataRequired()])
    password2 = PasswordField(label='Confirm Password:', validators=[EqualTo('password1'), DataRequired()])
    submit    = SubmitField(label='Create account')
# Thanks to the wtform.validators library it works with flask Form automatically this means that since we have created this class inheriting FlaskForm if we create functions
# with the name validate_field if field is an atribute of the class RegisterForm it will automatically execute this validations when an instance of the class is been created.
    def validate_username(self, username_to_check):
        user = User.query.filter_by(username=username_to_check.data).first()
        if user:
            raise ValidationError('Username already exist! Plase try a different username')
        
    def validate_email_address(self, email_address_to_check):
        email_address = User.query.filter_by(email_address=email_address_to_check.data).first()
        if email_address:
            raise ValidationError('Email address already exist! Please try a different address')

class LoginForm(FlaskForm):
    username = StringField(label='User Name:',validators=[DataRequired()])
    password = PasswordField(label='Password:', validators=[DataRequired()])
    submit    = SubmitField(label='Create account')

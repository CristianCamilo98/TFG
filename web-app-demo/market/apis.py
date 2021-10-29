from market import app
from market  import api

class HelloWorld(Resource):
    def get(self):
        return {"data": "Hello World"}

api.add_resource(HelloWorld,"/helloworld")

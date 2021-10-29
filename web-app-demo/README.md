To run flask we will have to execute:
```flask run```
To be able to run this we will need to set up some envirionment variables:
export FLASK_APP=market.py
export FLASK_DEBUG=1   # For easier use while developing the app :) 

## Lets try use mysql docker
docker un mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=password mysql

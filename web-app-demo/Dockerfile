FROM mysql:5.7

COPY mysql/mysqld.cnf /etc/mysql/mysql.conf.d
COPY flask_pre_models.sql /docker-entrypoint-initdb.d/
COPY init_mysql.sh /docker-entrypoint-initdb.d/
EXPOSE 3306

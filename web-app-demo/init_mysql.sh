#!/bin/bash

mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -e "drop database flask_pre_models;"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -e "create database flask_pre_models"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD flask_pre_models < flask_pre_models.sql

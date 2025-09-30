#!/bin/bash

docker run --name mysql -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=docker_pwd -e MYSQL_DATABASE=docker_db -e MYSQL_USER=docker_usr -e MYSQL_PASSWORD=docker_pwd mysql

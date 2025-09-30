#!/bin/bash

docker run --name mongodb -d -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=mongo_usr -e MONGO_INITDB_ROOT_PASSWORD=mongo_pwd mongo

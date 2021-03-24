#!/bin/bash
# Copyright 2019 the Deno authors. All rights reserved. MIT license.
# Copyright 2020 justjavac. All rights reserved. MIT license.
# TODO(everyone): Keep this script simple and easily auditable.


install_postgres_mysql() { 
  cd ~/EnvSetup/config/db
  docker-compose -up -d
}

install_mongodb() { 
  docker run -d -p 27017:27017 --name -v /data/db/mongodb:/data/db mongodb dockerfile/mongodb mongod --smallfiles
  echo "Client Command"
  echo "docker run -it --rm --link mongodb:mongodb dockerfile/mongodb bash -c 'mongo --host mongodb'"
}

install_couchdb() {
  docker run -d --name couchdb -p 8091-8094:8091-8094 -p 11210:11210 couchbase 
  echo "Client Command"
  echo "visit http://localhost:8091 to create your cluster"
}

install_redis() {
  docker run -d -p 6379:6379 -v /data/db/redis:/data --name redis dockerfile/redis redis-server /etc/redis/redis.conf --requirepass 20090909
  echo "Client Command"
  echo "docker run -it --rm --link redis:redis dockerfile/redis bash -c 'redis-cli -h redis'"
}

install_hasura_cli() {
	curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | bash
	echo  "or install globally on your system"
	npm install --global hasura-cli@latest
	echo "run hasura init to start"
}

install_mongo_redis() {
  mkdir -pv ~/development/db
  cd ~/development/db
  cat >> docker-compose.yml << EOF
version: '3'
services:
  mongo:
    container_name: dev-mongo
    image: mongo
    ports:
      - '27017:27017'
  redis:
    container_name: dev-redis
    image: redis
    ports:
      - '6379:6379'
  rabbitmq:
    container_name: dev-rabbitmq
    image: rabbitmq
    ports:
      - '15672:15672'
      - '5672:5672'
EOF
}

echo "==========================================================="
echo "installing database environment for you..."
echo "==========================================================="

cd

while true; do
  read -r -p "    [1] Postgres+Mysql [2] Mongodb+Redis [3] Couchdb [4] Hasura:  " opt
  case $opt in
    1)
      install_postgres_mysql
      break
      ;;
    2)
      install_mongo_redis
      break
      ;;
    3)
      install_couchdb
      break
      ;;
    4)
      install_hasura_cli
      break
      ;;
    *)
      echo "Please choose a correct answer"
      ;;
  esac
done

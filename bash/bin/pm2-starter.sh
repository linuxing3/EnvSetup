#!/usr/bin/env bash

# jupyter-lab-server.sh
# cd /home/pi/workspace/notebooks
# jupyter-lab --ip 0.0.0.0 --port 8888 > /home/pi/workspace/notebooks/notebooks.log
# /usr/bin/python3 /home/pi/.local/bin/jupyter-lab --ip 0.0.0.0 --port 8888
pm2 start jupyter-lab-server.sh

# go-admin-server.sh
# /home/pi/gopath/src/github.com/wenjianzhang/go-admin
# ./go-admin server -c config/settings.dev.yml -m dev
pm2 start go-admin-server.sh 

# nps-server.sh
# /usr/bin/nps service
pm3 start nps-server.sh

# caddy-web-server.sh
# /usr/bin/caddy run --environ --config /etc/caddy/Caddyfile
pm2 start caddy-web-server.sh

# cd ~/gogs-repositories
# gogs web

# /usr/lib/postgresql/11/bin/postgres -D /var/lib/postgresql/11/main -c config_file=/etc/postgresql/11/main/postgresql.conf

# /usr/sbin/mysqld

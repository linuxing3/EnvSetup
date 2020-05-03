#!/usr/bin/env bash

echo "Installing nginx"
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install --no-install-recommends --no-install-suggests -y ca-certificates libssl1.1
sudo apt-get install -y nginx
sudo touch /etc/nginx/sites-enabled/default
echo "Installed nginx"
# [optional]
# sudo apt-get clean && rm -rf /var/lib/apt/lists/*
# sudo rm /etc/nginx/sites-enabled/default

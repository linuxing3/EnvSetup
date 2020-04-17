#!/bin/bash

read -p "请输入username:" username
git config --global user.name $username

read -p "请输入email:" email
git config --global user.email $email

git config --global credential.helper store

echo "Your password will be stored in .git-credential file"


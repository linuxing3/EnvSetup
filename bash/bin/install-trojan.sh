#!/bin/bash

read -p "请输入Domain:" domain
read -p "请输入Password:" password
echo "\$domain
\$password
"|bash <(curl -sL https://scaleya.netlify.com/share/trojan.sh)


#!/bin/bash

read -p "请输入username:" username
read -p "请输入password:" password

useradd -m -U -p $password -u 88888 $username 
usermod -aG sudo $username

cat >> /etc/sudoers << EOF
$username ALL=(ALL:ALL) ALL
EOF

cd /home/$username

echo "Your user was created"


#!/bin/bash

read -p "请输入Domain:" domain

#申请https证书
systemctl stop caddy
systemctl stop nginx
curl https://get.acme.sh | sh

if [ ! -d /etc/letsencrypt/dongxishijie.xyz_ecc ]:
	mkdir /etc/letsencrypt/dongxishijie.xyz_ecc
fi

~/.acme.sh/acme.sh  --issue  -d $domain  --standalone
~/.acme.sh/acme.sh  --installcert  -d  $domain   \
	--key-file   /etc/letsencrypt/dongxishijie.xyz_ecc/private.key \
	--fullchain-file  /etc/letsencrypt/dongxishijie.xyz_ecc/fullchain.cer

#!/bin/bash

read -p "请输入Domain:" domain

#申请https证书
systemctl stop caddy
systemctl stop nginx
curl https://get.acme.sh | sh

if [ ! -d /etc/letsencrypt/$domain_ecc]:
	mkdir /etc/letsencrypt/$domain_ecc
fi

~/.acme.sh/acme.sh  --issue  -d $domain  --standalone
~/.acme.sh/acme.sh  --installcert  -d  $domain   \
	--key-file   /etc/letsencrypt/$domain_ecc/private.key \
	--fullchain-file  /etc/letsencrypt/$domain_ecc/fullchain.cer

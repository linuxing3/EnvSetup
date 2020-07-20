#!/bin/bash

read -p "请输入Domain:" domain

#申请https证书
curl https://get.acme.sh | sh

mkdir "/etc/letsencrypt/$domain"

~/.acme.sh/acme.sh  --issue  -d $domain  --standalone
~/.acme.sh/acme.sh  --installcert  -d  $domain   \
	--key-file   /etc/letsencrypt/$domain/private.key \
	--fullchain-file  /etc/letsencrypt/$domain/fullchain.cer

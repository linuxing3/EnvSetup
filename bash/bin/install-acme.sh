#!/bin/bash

read -p "请输入Domain:" domain

#申请https证书
curl https://get.acme.sh | sh

~/.acme.sh/acme.sh  --issue  -d $domain  --standalone
~/.acme.sh/acme.sh  --installcert  -d  $domain   \
	--key-file   ~/.acme.sh/$domain/private.key \
	--fullchain-file  ~/.acme.sh/$domain/fullchain.cer

echo "======================="
echo "请输入绑定到本VPS的域名"
echo "======================="
read your_domain
real_addr=`ping ${your_domain} -c 1 | sed '1{s/[^(]*(//;s/).*//;q}'`
local_addr=`curl ipv4.icanhazip.com`
if [ $real_addr == $local_addr ] ; then
    echo "Start issue certificate with your domain"
   
    ~/.acme.sh/acme.sh  --issue  -d $your_domain  --standalone

    echo "Start install certificates in /usr/local/etc/"
    ~/.acme.sh/acme.sh  --installcert  -d  $your_domain   \
        --key-file   /usr/local/etc/xray/ssl/xray_ssl.key \
        --cert-file /usr/local/etc/xray/ssl/xray_ssl.crt \
        --fullchain-file /usr/local/etc/xray/ssl/xray_ssl_fullchain.crt
    
    if test -s /usr/local/etc/xray/ssl/xray_ssl.crt; then
      echo "systemctl restart nginx"
    else
    	echo "申请证书失败"
    fi
else
    echo "================================"
    echo "域名解析地址与本VPS IP地址不一致"
    echo "本次安装失败，请确保域名解析正常"
    echo "================================"
fi	

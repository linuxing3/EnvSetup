echo "======================="
echo "请输入绑定到本VPS的域名"
echo "======================="
read your_domain
real_addr=`ping ${your_domain} -c 1 | sed '1{s/[^(]*(//;s/).*//;q}'`
local_addr=`curl ipv4.icanhazip.com`
if [ $real_addr == $local_addr ] ; then
    ~/.acme.sh/acme.sh  --issue  -d $your_domain  --standalone
    ~/.acme.sh/acme.sh  --installcert  -d  $your_domain   \
        --key-file   /usr/src/trojan-cert/private.key \
        --fullchain-file /usr/src/trojan-cert/fullchain.cer
    if test -s /usr/src/trojan-cert/fullchain.cer; then
      echo "请将/usr/src/trojan-cert/下的fullchain.cer下载放到客户端trojan-cli文件夹"
      systemctl restart trojan
      systemctl start nginx
    else
    	echo "申请证书失败"
    fi
else
    echo "================================"
    echo "域名解析地址与本VPS IP地址不一致"
    echo "本次安装失败，请确保域名解析正常"
    echo "================================"
fi	

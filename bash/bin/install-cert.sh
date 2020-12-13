echo "======================="
echo "请输入绑定到本VPS的域名"
echo "======================="
read your_domain
real_addr=`ping ${your_domain} -c 1 | sed '1{s/[^(]*(//;s/).*//;q}'`
local_addr=`curl ipv4.icanhazip.com`
if [ $real_addr == $local_addr ] ; then
    echo "开始签发证书"
   
    ~/.acme.sh/acme.sh  --issue  -d $your_domain  --standalone

    echo "证书安装在~/acme.sh/$your_domain/"
    ~/.acme.sh/acme.sh  --installcert  -d  $your_domain   \
        --key-file ~/acme.sh/$your_domain/$your_domain.key \
        --cert-file ~/acme.sh/$your_domain/$your_domain.cer \
        --fullchain-file ~/acme.sh/$your_domain/fullchain.cer
    
    if test -s ~/acme.sh/$your_domain/$your_domain.cer; then
      echo "申请证书成功"
    else
      echo "申请证书失败"
    fi
else
    echo "================================"
    echo "域名解析地址与本VPS IP地址不一致"
    echo "本次安装失败，请确保域名解析正常"
    echo "================================"
fi

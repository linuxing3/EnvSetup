#!/usr/bin/env bash
echo " install nps tunnel server "
a=$(arch)
if [[ "x86_64" == "${a}" ]]; then 
  version="amd64" 
fi
echo "Your system architecture is $a, downloading ${version} version"

cd
rm -rf nps 
mkdir nps 
cd nps
wget "https://github.com/ehang-io/nps/releases/download/v0.26.6/linux_${version}_server.tar.gz" 

tar -xvf "linux_${version}_server.tar.gz"

sed -i 's/http_proxy_port=.*$/http_proxy_port=8081/g' conf/nps.conf
sed -i 's/https_proxy_port=.*$/https_proxy_port=8443/g' conf/nps.conf


#web
sed -i 's/web_host=.*$/web_host=xuqinji.top/g ' conf/nps.conf
sed -i 's/web_username=.*$/web_username=admin/g' conf/nps.conf
sed -i 's/web_password=.*$/web_password=mm123456/g ' conf/nps.conf
sed -i 's/web_port = 8090/web_port=8090/g' conf/nps.conf

echo "----------------------------------------------------------"
echo "Server Setting Examples"
cat conf/nps.conf 

echo "----------------------------------------------------------"
echo "Client Setting Examples"
echo "[Thinkpad] # 这个就是remark字段，随意填写"
echo "host=nps.xunqinji.top # 映射域名"
echo "target_addr=192.168.1.2:80 # 内网ip，多个之间使用","分隔"

./nps install

echo "----------------------------------------------------------"
echo "Trying to start nps"
nps stop
nps start

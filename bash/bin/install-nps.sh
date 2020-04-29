#!/usr/bin/env bash

a=""
a=$(arch)
if [[ "${a}" ==  "x86_64" ]]; then 
  version="amd64" 
elif [[ "${a}" == "i686" ]]; then
  version="386"
elif [[ "${a}" == "armv7l" ]]; then
  version="arm_v7"
fi
echo "Your system architecture is ${a}, downloading ${version} version"


install_nps() {
	echo " install nps tunnel server "

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

	ps ax | grep nps
	if [[ ! -z $? ]];then
	  echo "nps server is ready!"
	fi
}


install_npc() {
	echo "----------------------------------------------------------"
	echo "Trying to install npc"
	cd
	rm -rf npc
	mkdir npc
	cd npc

	wget "https://github.com/ehang-io/nps/releases/download/v0.26.6/linux_${version}_client.tar.gz"
	tar xvf "linux_${version}_client.tar.gz"

	touch run-npc
	chmod +x run-npc
	cat >> run-npc << EOF
cd ~/npc
nohup ./npc &
EOF
	mv conf/npc.conf conf/npc.default.conf
	cat > conf/npc.conf << EOF
[common]
server_addr=35.235.80.5:8024
conn_type=tcp
vkey=qqyzkzldrxycbdzwwsgh
auto_reconnection=true
max_conn=1000
flow_limit=1000
rate_limit=1000
basic_username=978
basic_password=916
web_username=user
web_password=mm123456
crypt=true
compress=true

[tcp]
mode=tcp
server_port=11115
target_addr=127.0.0.1:22
EOF

	echo "Run npc in background"
  sudo ./npc install -config /home/${whoami}/npc/conf/npc.conf
  sudo systemctl enable Npc
	echo "Testing npc is running"
  sudo systemctl start Npc
  sudo systemctl status Npc
  echo "Checkout ~/npc/conf/npc.default.conf for more examples"
}


# Main function

main() {
	read -p "Install nps?" install
	if [[ $install == 'y' ]]; then
		install_nps
	else
		echo "Skipped install nps"
	fi

	read -p "Also install npc?" install
	if [[ $install == 'y' ]]; then
		install_npc
	else
		echo "Skipped install npc"
	fi
}

main

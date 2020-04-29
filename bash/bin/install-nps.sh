#!/usr/bin/env bash

a=""
a=$(arch)
if [[ "${a}" ==  "x86_64" ]]; then 
  version="amd64" 
elif [[ "${a}" == "x86" ]]; then
  version="i386"
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
	rm conf/npc.conf
	cat > conf/npc.conf << EOF
[common]
server_addr=35.235.80.5:8024
conn_type=tcp
vkey=91rjxgre6mross98
auto_reconnection=true
max_conn=1000
flow_limit=1000
rate_limit=1000
basic_username=11
basic_password=3
web_username=user
web_password=1234
crypt=true
compress=true
#pprof_addr=0.0.0.0:9999

[health_check_test1]
health_check_timeout=1
health_check_max_failed=3
health_check_interval=1
health_http_url=/
health_check_type=http
health_check_target=127.0.0.1:80

[health_check_test2]
health_check_timeout=1
health_check_max_failed=3
health_check_interval=1
health_check_type=tcp
health_check_target=127.0.0.1:80

[web]
host=nps.xunqinji.top
target_addr=127.0.0.1:80

[tcp]
mode=tcp
server_port=7000
target_addr=127.0.0.1:22

[socks5]
mode=socks5
server_port=19009
multi_account=multi_account.conf

[file]
mode=file
server_port=7500
local_path=/home/pi/Downloads
strip_pre=/web/

[http]
mode=httpProxy
server_port=19004

[udp]
mode=udp
server_port=12253
target_addr=114.114.114.114:53

[ssh_secret]
mode=secret
password=ssh2
target_addr=192.168.1.1:22

[ssh_p2p]
mode=p2p
password=ssh3

[secret_ssh]
local_port=2001
password=ssh2

[p2p_ssh]
local_port=2002
password=ssh3
target_addr=192.168.1.1:22
EOF

	echo "Run npc in background"
	./run-npc

	echo "Testing npc is running"
	netstat -nelp | grep npc
	if [[ ! -z $? ]];then
	  echo "Started client"
	fi
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

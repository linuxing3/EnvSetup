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

if ! command -v "dialog" >/dev/null 2>&1; then
  sudo apt install -y dialog
else
  echo "Dialog installed!"
fi

install_nps() {
	echo " install nps tunnel server "

	cd
	rm -rf nps
	mkdir nps
	cd nps
	wget "https://github.com/ehang-io/nps/releases/download/v0.26.9/linux_${version}_server.tar.gz"

	tar -xvf "linux_${version}_server.tar.gz"

	sed -i 's/http_proxy_port=.*$/http_proxy_port=8081/g' conf/nps.conf
	sed -i 's/https_proxy_port=.*$/https_proxy_port=8443/g' conf/nps.conf

	#web
	sed -i 's/web_host=.*$/web_host=localhost/g ' conf/nps.conf
	sed -i 's/web_username=.*$/web_username=admin/g' conf/nps.conf
	sed -i 's/web_password=.*$/web_password=mm123456/g ' conf/nps.conf
	sed -i 's/web_port = 8090/web_port=8090/g' conf/nps.conf

	echo "----------------------------------------------------------"
	echo "Server Setting Examples"
  sudo mkdir -p /etc/nps/conf
	sudo cp conf/*.* /etc/nps/conf/

	sudo ./nps install

	echo "----------------------------------------------------------"
	echo "Trying to start nps"
	sudo nps stop
	sudo nps start

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

	wget "https://github.com/ehang-io/nps/releases/download/v0.26.9/linux_${version}_client.tar.gz"
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
server_addr=your_domain:8024
conn_type=tcp
vkey=13901229638
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
server_port=11116
target_addr=127.0.0.1:22
EOF

  user=$(whoami)
  dir=""
  if [[ "${user}" == "root" ]]; then
    dir="/root"
  else
    dir="/home/${user}"
  fi
	echo "Uninstall npc is" 
  sudo systemctl stop Npc
  sudo ./npc uninstall

  sudo ./npc install -config "${dir}/npc/conf/npc.conf"
  sudo systemctl enable Npc
	echo "Testing npc is running"
  sudo systemctl stop Npc
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

ui() {
  num=$(dialog --title " Nps 一键安装自动脚本" \
    --checklist "请输入:" 20 70 5 \
    "nps" "NPS Server" 0 \
    "npc" "NPC Client" 0 \
    3>&1 1>&2 2>&3 3>&1)
  case $num in
    nps)
      install_nps
    ;;
    npc)
      install_npc
      ;;
  esac
}

ui

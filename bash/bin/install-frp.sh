#!/usr/bin/env bash
echo " install frp tunnel server "
a=$(arch)
if [[ "x86_64" == "${a}" ]]; then 
  version="amd64" 
fi
echo "Your system architecture is $a, downloading ${version} version"

cd

rm -rf "frp_0.33.0_linux_${version}.tar.gz"
rm -rf "frp_0.33.0_linux_${version}"

wget "https://github.com/fatedier/frp/releases/download/v0.33.0/frp_0.33.0_linux_${version}.tar.gz"

tar -xvf "frp_0.33.0_linux_${version}.tar.gz"
cd frp_0.33.0_linux_${version}/

if [[ ! -e "/usr/bin/frps" ]] ; then
  echo "Copy frps"
  cp frps /usr/bin/
elif [[ ! -e "/usr/bin/frpc" ]]; then
  echo "Copy frpc"
  cp frpc /usr/bin/
else
  echo "frps and frpc exists!"
fi

if [[ ! -d "/etc/frp" ]] ; then
  mkdir /etc/frp
else
  echo "/etc/frp exists!"
fi
cp frps.ini /etc/frp/

cat >> /etc/frp/frps.ini << EOF
dashboard_port = 7500
token = mm123456
dashboard_user = admin
dashboard_pwd = mm123456
EOF

if [[ ! -e "/etc/systemd/system/frps.service" ]] ; then
  cp systemd/frps.service /etc/systemd/system/frps.service
else
  echo "frp service exists!"
fi

systemctl stop frps
systemctl daemon-reload

systemctl start frps
systemctl status frps

cat /etc/frp/frps.ini 

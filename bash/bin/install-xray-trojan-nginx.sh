#!/bin/bash

blue() {
    echo -e "\033[34m\033[01m$1\033[0m"
}
green() {
    echo -e "\033[32m\033[01m$1\033[0m"
}
red() {
    echo -e "\033[31m\033[01m$1\033[0m"
}
yellow() {
    echo -e "\033[33m\033[01m$1\033[0m"
}

logcmd() {
    eval $1 | tee -ai /var/atrandys.log
}

source /etc/os-release
RELEASE=$ID
VERSION=$VERSION_ID
cat >>/usr/src/atrandys.log <<-EOF
== Script: atrandys/xray/install.sh
== Time  : $(date +"%Y-%m-%d %H:%M:%S")
== OS    : $RELEASE $VERSION
== Kernel: $(uname -r)
== User  : $(whoami)
EOF

sleep 2s

check_release() {
    green "$(date +"%Y-%m-%d %H:%M:%S") ==== 检查系统版本"
    if [ "$RELEASE" == "centos" ]; then
        systemPackage="yum"
        yum install -y wget
        if [ "$VERSION" == "6" ]; then
            red "$(date +"%Y-%m-%d %H:%M:%S") - 暂不支持CentOS 6.\n== Install failed."
            exit
        fi
        if [ "$VERSION" == "5" ]; then
            red "$(date +"%Y-%m-%d %H:%M:%S") - 暂不支持CentOS 5.\n== Install failed."
            exit
        fi
        if [ -f "/etc/selinux/config" ]; then
            CHECK=$(grep SELINUX= /etc/selinux/config | grep -v "#")
            if [ "$CHECK" == "SELINUX=enforcing" ]; then
                green "$(date +"%Y-%m-%d %H:%M:%S") - SELinux状态非disabled,关闭SELinux."
                setenforce 0
                sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
                #loggreen "SELinux is not disabled, add port 80/443 to SELinux rules."
                #loggreen "==== Install semanage"
                #logcmd "yum install -y policycoreutils-python"
                #semanage port -a -t http_port_t -p tcp 80
                #semanage port -a -t http_port_t -p tcp 443
                #semanage port -a -t http_port_t -p tcp 37212
                #semanage port -a -t http_port_t -p tcp 37213
            elif [ "$CHECK" == "SELINUX=permissive" ]; then
                green "$(date +"%Y-%m-%d %H:%M:%S") - SELinux状态非disabled,关闭SELinux."
                setenforce 0
                sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config
            fi
        fi
        firewall_status=$(firewall-cmd --state)
        if [ "$firewall_status" == "running" ]; then
            green "$(date +"%Y-%m-%d %H:%M:%S") - FireWalld状态非disabled,添加80/443到FireWalld rules."
            firewall-cmd --zone=public --add-port=80/tcp --permanent
            firewall-cmd --zone=public --add-port=443/tcp --permanent
            firewall-cmd --reload
        fi
        while [ ! -f "nginx-release-centos-7-0.el7.ngx.noarch.rpm" ]; do
            wget http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
            if [ ! -f "nginx-release-centos-7-0.el7.ngx.noarch.rpm" ]; then
                red "$(date +"%Y-%m-%d %H:%M:%S") - 下载nginx rpm包失败，继续重试..."
            fi
        done
        rpm -ivh nginx-release-centos-7-0.el7.ngx.noarch.rpm --force --nodeps
        #logcmd "rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm --force --nodeps"
        #loggreen "Prepare to install nginx."
        #yum install -y libtool perl-core zlib-devel gcc pcre* >/dev/null 2>&1
        yum install -y epel-release
    elif [ "$RELEASE" == "ubuntu" ]; then
        systemPackage="apt-get"
        if [ "$VERSION" == "14" ]; then
            red "$(date +"%Y-%m-%d %H:%M:%S") - 暂不支持Ubuntu 14.\n== Install failed."
            exit
        fi
        if [ "$VERSION" == "12" ]; then
            red "$(date +"%Y-%m-%d %H:%M:%S") - 暂不支持Ubuntu 12.\n== Install failed."
            exit
        fi
        ufw_status=$(systemctl status ufw | grep "Active: active")
        if [ -n "$ufw_status" ]; then
            ufw allow 80/tcp
            ufw allow 443/tcp
            ufw reload
        fi
        apt-get update >/dev/null 2>&1
    elif [ "$RELEASE" == "debian" ]; then
        systemPackage="apt-get"
        ufw_status=$(systemctl status ufw | grep "Active: active")
        if [ -n "$ufw_status" ]; then
            ufw allow 80/tcp
            ufw allow 443/tcp
            ufw reload
        fi
        apt-get update >/dev/null 2>&1
    else
        red "$(date +"%Y-%m-%d %H:%M:%S") - 当前系统不被支持. \n== Install failed."
        exit
    fi
}

check_port() {
    green "$(date +"%Y-%m-%d %H:%M:%S") ==== 检查端口"
    $systemPackage -y install net-tools
    Port80=$(netstat -tlpn | awk -F '[: ]+' '$1=="tcp"{print $5}' | grep -w 80)
    Port443=$(netstat -tlpn | awk -F '[: ]+' '$1=="tcp"{print $5}' | grep -w 443)
    if [ -n "$Port80" ]; then
        process80=$(netstat -tlpn | awk -F '[: ]+' '$5=="80"{print $9}')
        red "$(date +"%Y-%m-%d %H:%M:%S") - 80端口被占用,占用进程:${process80}\n== Install failed."
        exit 1
    fi
    if [ -n "$Port443" ]; then
        process443=$(netstat -tlpn | awk -F '[: ]+' '$5=="443"{print $9}')
        red "$(date +"%Y-%m-%d %H:%M:%S") - 443端口被占用,占用进程:${process443}.\n== Install failed."
        exit 1
    fi
}
install_nginx() {
    green "$(date +"%Y-%m-%d %H:%M:%S") ==== 安装nginx"
    $systemPackage install -y nginx
    if [ ! -d "/etc/nginx" ]; then
        red "$(date +"%Y-%m-%d %H:%M:%S") - 看起来nginx没有安装成功，请先使用脚本中的删除xray功能，然后再重新安装.\n== Install failed."
        exit 1
    fi

    cat >/etc/nginx/nginx.conf <<-EOF
user  www-data;
worker_processes  1;
#error_log  /etc/nginx/error.log warn;
#pid    /var/run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;
events {
    worker_connections  1024;
}
stream { 
  map \$ssl_preread_server_name \$backend_name { 
    $your_domain web; 
    pro.$your_domain trojan;
    xray.$your_domain xray;
    default web; 
  } 
  
  upstream trojan { 
    server 127.0.0.1:10110; 
  }
  
  upstream xray {
    server 127.0.0.1:10115;
  }
  
  upstream web { 
    server 127.0.0.1:44321;
  }

  server { 
    listen 443 reuseport; 
    listen [::]:443 reuseport; 
    proxy_pass \$backend_name; 
    ssl_preread on; 
  }
}
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';
    #access_log  /etc/nginx/access.log  main;
    sendfile        on;
    #tcp_nopush     on;
    keepalive_timeout  120;
    client_max_body_size 20m;
    # SSL Settings
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
    ssl_prefer_server_ciphers on;
    #gzip  on;
    include /etc/nginx/conf.d/*.conf;
}
EOF

    cat >/etc/nginx/conf.d/default.conf <<-EOF
map \$http_upgrade \$connection_upgrade {
    default upgrade;
    ''      close;
}

server {
    listen       10111;
    server_name  $your_domain;
    location / {
      if (\$http_host !~ "^$your_domain$") {
           rewrite ^(.*) https://$your_domain$1 permanent;
            }
      if (\$server_port !~ 44321) {
           rewrite ^(.*) https://$your_domain$1 permanent;
      }

       proxy_redirect off;
       proxy_set_header Host \$host;
       proxy_set_header X-Real-IP \$remote_addr;
       proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
   }
}

server {
    listen 44321 ssl http2;
    server_name $your_domain;
    root /var/www/html;
    index index.php index.html index.htm;

    ssl_certificate /root/.acme.sh/$your_domain/fullchain.cer;
    ssl_certificate_key /root/.acme.sh/$your_domain/$your_domain.key;
    ssl_stapling on;
    ssl_stapling_verify on;
    add_header Strict-Transport-Security "max-age=31536000";
    
    location /nps {
       proxy_pass http://127.0.0.1:8090;
    }
    location /trojan {
       proxy_pass http://127.0.0.1:8889;
    }    
}
EOF
    green "$(date +"%Y-%m-%d %H:%M:%S") ==== 检测nginx配置文件"
    nginx -t
    #CHECK=$(grep SELINUX= /etc/selinux/config | grep -v "#")
    #if [ "$CHECK" != "SELINUX=disabled" ]; then
    #    loggreen "设置Selinux允许nginx"
    #    cat /var/log/audit/audit.log | grep nginx | grep denied | audit2allow -M mynginx
    #    semodule -i mynginx.pp
    #fi
    systemctl enable nginx.service
    systemctl restart nginx.service

    # 申请https证书
    green "$(date +"%Y-%m-%d %H:%M:%S") - 使用acme.sh申请https证书."
    curl https://get.acme.sh | sh
    # ~/.acme.sh/acme.sh --issue -d $your_domain --webroot /var/www/html
    ~/.acme.sh/acme.sh --issue -d $your_domain --standalone
    if test -s /root/.acme.sh/$your_domain/fullchain.cer; then
        green "$(date +"%Y-%m-%d %H:%M:%S") - 申请https证书成功."
    else
        cert_failed="1"
        red "$(date +"%Y-%m-%d %H:%M:%S") - 申请证书失败，请尝试手动申请证书."
    fi

    install_xray
}

install_xray() {
    green "$(date +"%Y-%m-%d %H:%M:%S") ==== 安装xray"
    mkdir /usr/local/etc/xray/
    mkdir /usr/local/etc/xray/ssl

    bash <(curl -L https://raw.githubusercontent.com/XTLS/Xray-install/main/install-release.sh)

    cd /usr/local/etc/xray/
    rm -f config.json
    v2uuid=$(cat /proc/sys/kernel/random/uuid)

    cat >/usr/local/etc/xray/config.json <<-EOF
{
    "log": {
        "loglevel": "warning"
    },
    "api": null,
    "dns": {},
    "routing": {
        "domainStrategy": "AsIs",
        "rules": [
        {
            "type": "field",
            "ip": [
            "geoip:private"
            ],
            "outboundTag": "block"
        }
        ]
    },
    "policy": {},
    "inbounds": [
        {
            "listen": "0.0.0.0", 
            "port": 10115, 
            "protocol": "vless", 
            "settings": {
                "clients": [
                    {
                        "id": "$v2uuid", 
                        "level": 0, 
                        "email": "a@b.com",
                        "flow":"xtls-rprx-direct"
                    }
                ], 
                "decryption": "none", 
                "fallbacks": [
                    {
                      "dest": 10110
                    }, 
                    {
                      "dest": 1310 
                    }, 
		            {
		              "path": "/vlessws",
		              "dest": 1234,
		              "xver": 1
		            },
		            {
		              "path": "/vmesstcp",
		              "dest": 2345,
		              "xver": 1
		            },
		            {
		              "path": "/vmessws",
		              "dest": 3456,
		              "xver": 1
		            }
                ]
            }, 
            "streamSettings": {
                "network": "tcp", 
                "security": "xtls", 
                "xtlsSettings": {
                    "serverName": "$your_domain", 
                    "alpn": [
                        "h2", 
                        "http/1.1"
                    ], 
                    "certificates": [
                        {
                            "certificateFile": "/usr/local/etc/xray/ssl/fullchain.cer", 
                            "keyFile": "/usr/local/etc/xray/ssl/private.key"
                        }
                    ]
                }
            }
        },
        {
	      "port": 1310,
	      "listen": "127.0.0.1",
	      "protocol": "trojan",
	      "settings": {
	        "clients": [
	          {
	            "password": "20090909"
	          }
	        ],
	        "fallbacks": [
	          {
	            "dest": 15034
	          }
	        ]
	      },
	      "streamSettings": {
	        "network": "tcp",
	        "security": "none",
	        "tcpSettings": {
	          "acceptProxyProtocol": true
	        }
	      }
	    },
	    {
	      "port": 1234,
	      "listen": "127.0.0.1",
	      "protocol": "vless",
	      "settings": {
	        "clients": [
	          {
	            "id": "$v2uuid"
	          }
	        ],
	        "decryption": "none"
	      },
	      "streamSettings": {
	        "network": "ws",
	        "security": "none",
	        "wsSettings": {
	          "acceptProxyProtocol": true,
	          "path": "/vlessws"
	        }
	      }
	    },
	    {
	      "port": 2345,
	      "listen": "127.0.0.1",
	      "protocol": "vmess",
	      "settings": {
	        "clients": [
	          {
	            "id": "$v2uuid"
	          }
	        ]
	      },
	      "streamSettings": {
	        "network": "tcp",
	        "security": "none",
	        "tcpSettings": {
	          "acceptProxyProtocol": true,
	          "header": {
	            "type": "http",
	            "request": {
	              "path": [
	                "/vmesstcp"
	              ]
	            }
	          }
	        }
	      }
	    },
	    {
	      "port": 3456,
	      "listen": "127.0.0.1",
	      "protocol": "vmess",
	      "settings": {
	        "clients": [
	          {
	            "id": "$v2uuid"
	          }
	        ]
	      },
	      "streamSettings": {
	        "network": "ws",
	        "security": "none",
	        "wsSettings": {
	          "acceptProxyProtocol": true,
	          "path": "/vmessws"
	        }
	      }
	    }
    ], 
    "outbounds": [
        {
            "protocol": "freedom", 
            "settings": { }
        }
    ]
}
EOF
    cat >/usr/local/etc/xray/client.json <<-EOF
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "port": 1080,
            "listen": "127.0.0.1",
            "protocol": "socks",
            "settings": {
                "udp": true
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "vless",
            "settings": {
                "vnext": [
                    {
                        "address": "$your_domain",
                        "port": 443,
                        "users": [
                            {
                                "id": "$v2uuid",
                                "flow": "xtls-rprx-direct",
                                "encryption": "none",
                                "level": 0
                            }
                        ]
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "security": "xtls",
                "xtlsSettings": {
                    "serverName": "$your_domain"
                }
            }
        }
    ]
}
EOF

    green "设置伪装站"
    setup_sample

    systemctl enable xray.service
    sed -i "s/User=nobody/User=root/;" /etc/systemd/system/xray.service
    systemctl daemon-reload

    ~/.acme.sh/acme.sh --installcert -d $your_domain \
        --key-file /usr/local/etc/xray/ssl/private.key \
        --fullchain-file /usr/local/etc/xray/ssl/fullchain.cer \
        --reloadcmd "chmod -R 777 /usr/local/etc/xray/ssl && systemctl restart xray.service"

    cat >/usr/local/etc/xray/myconfig.json <<-EOF
{
地址：${your_domain}
端口：443
id：${v2uuid}
加密：none
流控：xtls-rprx-direct
别名：自定义
传输协议：tcp
伪装类型：none
底层传输：xtls
跳过证书验证：false
}
EOF

    green "== 安装完成."
    if [ "$cert_failed" == "1" ]; then
        green "======nginx信息======"
        red "申请证书失败，请尝试手动申请证书."
    fi
    green "==xray客户端配置文件存放路径=="
    green "/usr/local/etc/xray/client.json"
    echo
    echo
    green "==xray配置参数=="
    cat /usr/local/etc/xray/myconfig.json
    green "本次安装检测信息如下，如nginx与xray正常启动，表示安装正常："
    ps -aux | grep -e nginx -e xray

}

check_domain() {
    $systemPackage install -y wget curl unzip
    blue "Eenter your domain:"
    read your_domain
    real_addr=$(ping ${your_domain} -c 1 | sed '1{s/[^(]*(//;s/).*//;q}')
    local_addr=$(curl ipv4.icanhazip.com)
    if [ $real_addr == $local_addr ]; then
        green "域名解析地址与VPS IP地址匹配."
        install_nginx
    else
        red "域名解析地址与VPS IP地址不匹配."
        read -p "强制安装?请输入 [Y/n] :" yn
        [ -z "${yn}" ] && yn="y"
        if [[ $yn == [Yy] ]]; then
            sleep 1s
            install_nginx
        else
            exit 1
        fi
    fi
}

remove_xray() {
    green "$(date +"%Y-%m-%d %H:%M:%S") - 删除xray."
    systemctl stop xray.service
    systemctl disable xray.service
    systemctl stop nginx
    systemctl disable nginx
    if [ "$RELEASE" == "centos" ]; then
        yum remove -y nginx
    else
        apt-get -y autoremove nginx
        apt-get -y --purge remove nginx
        apt-get -y autoremove && apt-get -y autoclean
        find / | grep nginx | sudo xargs rm -rf
    fi
    rm -rf /usr/local/share/xray/ /usr/local/etc/xray/
    rm -f /usr/local/bin/xray
    rm -rf /etc/systemd/system/xray*
    rm -rf /etc/nginx
    rm -rf /usr/share/nginx/html/*
    rm -rf /root/.acme.sh/
    green "nginx & xray has been deleted."

}

install_trojan() {
    green "使用Jrohy大神的trojan管理程序进行安装"
    red "https://raw.githubusercontent.com/Jrohy/trojan/master/install.sh"
    green "=========================================="
    red "清除原有安装"
    green "=========================================="
    if [[ -d /home/mariadb ]]; then
        rm -rf /home/mariadb
    fi

    if [[ -d /usr/local/etc/trojan ]]; then
        rm -rf /usr/local/etc/trojan
    fi

    if [[ -e /usr/local/bin/trojan ]]; then
        rm /usr/local/bin/trojan
    fi

    red "建议和xray使用同样的证书和秘钥"
    red "/usr/local/etc/xray/ssl/fullchain.cer"
    red "/usr/local/etc/xray/ssl/private.key"

    sleep 3
    red "启动安装"
    source <(curl -sL https://git.io/trojan-install)

    green "=========================================="
    red "Changing trojan port to 10110"
    green "=========================================="

    sudo sed -i "s/443/10110/g" /usr/local/etc/trojan/config.json

    green "=========================================="
    red "Changing trojan web port to 8889"
    green "=========================================="
    sudo sed -i "s/web/web -p 8889/g" /etc/systemd/system/trojan-web.service
    sudo sed -i "s/80/8889/g" /usr/local/etc/trojan/config.json

    green "=========================================="
    red "Reloading daemon"
    green "=========================================="

    systemctl reload-daemon
    systemctl stop trojan
    systemctl start trojan
    systemctl stop trojan-web
    systemctl start trojan-web

    green "启动trojan终端管理程序"
    trojan
}

setup_sample() {
    green "=========================================="
    blue "$(date +"%Y-%m-%d %H:%M:%S") 设置伪装站"
    green "=========================================="
    rm -rf /var/www/html/*
    cd /var/www/html/
    wget https://github.com/linuxing3/EnvSetup/raw/master/config/nginx/sample-web-template.zip
    unzip sample-web-template.zip
}

install_cert() {
    echo "======================="
    echo "请输入绑定到本VPS的域名"
    echo "======================="
    read your_domain
    real_addr=$(ping ${your_domain} -c 1 | sed '1{s/[^(]*(//;s/).*//;q}')
    local_addr=$(curl ipv4.icanhazip.com)
    if [ $real_addr == $local_addr ]; then
        echo "开始签发证书"
        echo "原始证书安装在~/acme.sh/$your_domain"
        ~/.acme.sh/acme.sh --issue -d $your_domain --standalone

        echo "======================="
        echo "请输入安装目录"
        echo "======================="
        read cert_path
        sudo mkdir -p $cert_path
        ~/.acme.sh/acme.sh --installcert -d $your_domain \
        --key-file $cert_path/$your_domain.key \
        --cert-file $cert_path/$your_domain.cer \
        --fullchain-file $cert_path/fullchain.cer

        if test -s $cert_path/$your_domain.cer; then
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
}

function start_menu() {
    clear
    green " ===================================="
    green " Nginx/Trojan/Xray 一键安装自动脚本 2021-3-24 更新      "
    green " 系统：centos7+/debian9+/ubuntu16.04+"
    green " ===================================="
    echo
    green " 1. 安装 xray 全功能模式"
    green " 2. 更新 xray"
    red " 3. 删除 xray"
    green " 4. 查看配置参数"
    green " 5. 安装trojan"
    green " 6. 设置伪装站"
    green " 7. 单独安装证书"
    yellow " 0. Exit"
    echo
    read -p "输入数字:" num
    case "$num" in
    1)
        check_release
        check_port
        check_domain
        ;;
    2)
        bash <(curl -L https://raw.githubusercontent.com/XTLS/Xray-install/main/install-release.sh)
        systemctl restart xray
        ;;
    3)
        remove_xray
        ;;
    4)
        cat /usr/local/etc/xray/myconfig.json
        ;;
    5)
        check_release
        check_port
        install trojan
        ;;
    6)
        setup_sample
        ;;
    7)
        install_cert
        ;;
    0)
        exit 1
        ;;
    *)
        clear
        red "请输入正确选项"
        sleep 2s
        start_menu
        ;;
    esac
}

start_menu

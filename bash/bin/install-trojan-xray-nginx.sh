#!/bin/bash
# 字体颜色
blue(){
    echo -e "\033[34m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}

install_trojan(){
    red "使用Jrohy大神的trojan管理程序进行安装"
    red "https://raw.githubusercontent.com/Jrohy/trojan/master/install.sh"
    source <(curl -sL https://git.io/trojan-install)
    green "=========================================="
    green "$(date +"%Y-%m-%d %H:%M:%S") Changing trojan port to 10110"
    green "=========================================="
    sudo sed -i "s/443/10110/g" /usr/local/etc/trojan/config.json
    sudo sed -i "s/80/10111/g" /usr/local/etc/trojan/config.json
}

install_xray() {
    red "建议你在windows下使用ProxySu等工具安装，客户端使用最新WinXray"
    red "一键安装xray"
    bash <(curl -Ls https://raw.githubusercontent.com/atrandys/xray/main/install.sh)

    red "一键安装xray二进制文件"
    red "bash <(curl -L https://raw.githubusercontent.com/XTLS/Xray-install/main/install-release.sh)"

    green "=========================================="
    green "$(date +"%Y-%m-%d %H:%M:%S") Changing xray port to 10110"
    green "=========================================="
    sudo sed -i "s/443/10115" /usr/local/etc/xray/config.json

    green "安装完毕！"
}

setup_nginx_with_xray_and_trojan(){
    green "======================="
    blue "请输入绑定到本VPS的域名"
    green "======================="
    read your_domain
 
    if [ ! -d "/etc/nginx" ]; then
        red "$(date +"%Y-%m-%d %H:%M:%S") - 看起来nginx没有安装成功，请重新安装.\n== Install failed."
    exit 1
    fi
    mv /etc/nginx/nginx.conf /etc/nginx/nginx.default.conf
    cat > /etc/nginx/nginx.conf <<-EOF
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
    caddy.$your_domain caddy;
    xray.$your_domain xray;
    default web; 
  } 
  
  upstream trojan { 
    server 127.0.0.1:10110; 
  }
  
  upstream xray {
    server 127.0.0.1:10115;
  }
  
  upstream caddy { 
    server 127.0.0.1:44322; 
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

    cat > /etc/nginx/conf.d/proxy.conf <<-EOF
map \$http_upgrade \$connection_upgrade {
    default upgrade;
    ''      close;
}

server {
    listen       10111;
    server_name  pro.$your_domain;
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
    
}
EOF
setup_sample
green "======================="
blue "Done Setting nginx with trojan!"
green "======================="
}

setup_sample(){
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
    real_addr=`ping ${your_domain} -c 1 | sed '1{s/[^(]*(//;s/).*//;q}'`
    local_addr=`curl ipv4.icanhazip.com`
    if [ $real_addr == $local_addr ] ; then
        echo "开始签发证书"
        ~/.acme.sh/acme.sh --issue -d $your_domain --standalone

        echo "======================="
        echo "请输入安装目录"
        echo "======================="
        read cert_path
        echo "证书安装在~/acme.sh/$cert_path/"
        sudo mkdir -p $cert_path
        ~/.acme.sh/acme.sh  --installcert -d  $your_domain   \
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

start_menu(){
    clear
    green " ===================================="
    green " Nginx/Trojan/Xray 一键安装自动脚本 2020-2-27 更新      "
    green " 系统：centos7+/debian9+/ubuntu16.04+"
    green " ===================================="
    echo
    green " 1. 安装trojan"
    red " 2. 安装xray"
    blue " 3. 设置nginx-trojan-xray"
    green " 4. 安装web sample"
    red " 5. 安装证书"
    blue " 0. 退出脚本"
    echo
    read -p "请输入数字:" num
    case "$num" in
    1)
    install_trojan
    ;;
    2)
    install_xray
    ;;
    3)
    setup_nginx_with_xray_and_trojan
    ;;
    4)
    setup_sample
    ;;
    5)
    install_cert
    ;;
    0)
    exit 1
    ;;
    *)
    clear
    red "请输入正确数字"
    sleep 1s
    start_menu
    ;;
    esac
}

start_menu

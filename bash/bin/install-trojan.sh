#!/bin/bash
＃字体颜色
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
    source <(curl -sL https://git.io/trojan-install)
}

setup_trojan_nginx(){
    green "======================="
    blue "请输入绑定到本VPS的域名"
    green "======================="
    read your_domain
    real_addr=`ping ${your_domain} -c 1 | sed '1{s/[^(]*(//;s/).*//;q}'`
    local_addr=`curl ipv4.icanhazip.com`
    if [ $real_addr == $local_addr ] ; then
      green "=========================================="
      green "       域名解析正常，开始安装trojan"
      green "=========================================="
      sleep 1s
    fi
    
    sudo apt install -y nginx
    
    sudo mv /etc/nginx/sites-available/default /etc/nginx/sites-available.default 
    sudo cp ~/EnvSetup/config/nginx/bt/vhost/0.default.conf /etc/nginx/sites-available/default
    sudo sed -i "s/dongxishijie.xyz/$your_domain/g" /etc/nginx/sites-available/default
    
    sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
    sudo cp ~/EnvSetup/config/nginx/bt/nginx.trojan.conf /etc/nginx/nginx.conf
    sudo sed -i "s/dongxishijie.xyz/$your_domain/g" /etc/nginx/nginx.conf

    sudo mv /usr/local/etc/trojan/config.json /usr/local/etc/trojan/config.json.bak
    sudo cp ~/EnvSetup/config/trojan/dongxishijie/server.json /usr/local/etc/trojan/config.json
    sudo sed -i "s/dongxishijie.xyz/$your_domain/g" /usr/local/etc/trojan/config.json

}

setup_sample(){
    #设置伪装站
    sleep 5
    rm -rf /var/www/html/*
    cd /var/www/html/
    wget https://github.com/linuxing3/EnvSetup/raw/master/config/nginx/sample-web-template.zip
    unzip sample-web-template.zip
}

start_menu(){
    clear
    green " ===================================="
    green " Trojan 一键安装自动脚本 2020-2-27 更新      "
    green " 系统：centos7+/debian9+/ubuntu16.04+"
    green " ===================================="
    blue " 声明："
    red " *请不要在任何生产环境使用此脚本"
    red " *请不要有其他程序占用80和443端口"
    red " *若是第二次使用脚本，请先执行卸载trojan"
    green " ======================================="
    echo
    green " 1. 安装trojan"
    red " 2. 安装nginx"
    red " 3. 安装web sample"
    blue " 0. 退出脚本"
    echo
    read -p "请输入数字:" num
    case "$num" in
    1)
    install_trojan
    ;;
    2)
    setup_trojan_nginx
    ;;
    2)
    setup_sample
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

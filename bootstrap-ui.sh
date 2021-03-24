#!/usr/bin/env bash
# linuxing's Bash Boostrapping UI Script (LBBUS)
# by linuxing3 <linuxing3@qq.com>
# License: GNU GPLv3
#
#                                        _
#    ___ _ __   __ _  ___ ___     __   _(_) 
#   / __| -_ \ / _- |/ __/ _ \____\ \ / 
#   \__ \ |_) | (_| | (_|  __/_____\ V /
#   |___/ .__/ \__._|\___\___|      \_/ 
#       |_|
#
#

set -eo pipefail

source ~/EnvSetup/bash/custom/init.sh

function install_vim(){
  green "======================="
  blue "Installing space-vim for you"
  green "======================="
  cd
  bash EnvSetup/bash/bin/install-vim.sh
  cd
}

function install_bash(){
  green "======================="
  blue "Installing oh-my-bash for you"
  green "======================="
  cd
  bash ~/EnvSetup/bash/bin/install-bash.sh

  cd
  mv .bashrc .bashrc.default
  cp ~/EnvSetup/bash/custom/bashrc.default  ~/.bashrc 
}

function install_tmux(){
  green "======================="
  blue "Installing oh-my-tmux for you"
  green "======================="
  cd
  bash EnvSetup/bash/bin/install-tmux.sh
  cd
}

function install_db(){
  green "======================="
  blue "Installing development databases for you"
  green "======================="
  cd
  bash EnvSetup/bash/bin/install-db.sh
  cd
}

function install_emacs(){
  green "======================="
  blue "Installing doom emacs for you"
  green "======================="
  cd
  bash EnvSetup/bash/bin/install-emacs.sh
  cd
}

function install_python(){
  green "======================="
  blue "Installing python+pyenv+pipenv+ansible"
  green "======================="
  cd
  bash EnvSetup/bash/bin/install-python.sh
  cd
}

function install_go(){
  green "======================="
  blue "Installing go"
  green "======================="
  cd
  bash EnvSetup/bash/bin/install-go.sh
  cd
}

function install_deno(){
  green "======================="
  blue "Installing deno"
  green "======================="
  cd
  bash EnvSetup/bash/bin/install-deno.sh
  cd
}

function install_docker(){
  green "======================="
  blue "Installing docker"
  green "======================="
  cd
  bash EnvSetup/bash/bin/install-docker.sh
  bash EnvSetup/bash/bin/install-docker-compose.sh
  cd
}



function install_rust(){
  green "======================="
  blue "Installing rust"
  green "======================="
  cd
  bash EnvSetup/bash/bin/install-rust.sh
  cd
}

function install_nvm(){
  green "======================="
  blue "Installing nvm+npm"
  green "======================="
  cd
  bash EnvSetup/bash/bin/install-nodejs.sh
  cd
}

function install_caddy(){
  green "======================="
  blue "Installing caddy"
  green "======================="
  cd
  bash EnvSetup/bash/bin/install-caddy.sh
  cd
}

function install_trojan(){
  green "======================="
  blue "Installing trojan"
  green "======================="
  cd
  bash EnvSetup/bash/bin/install-trojan.sh
  cd
}

function install_xray(){
  green "======================="
  blue "Installing xray trojan with nginx"
  green "======================="
  cd
  bash EnvSetup/bash/bin/install-xray-trojan-nginx.sh
  cd
}

function install_nps(){
  green "======================="
  blue "Installing nps"
  green "======================="
  cd
  bash EnvSetup/bash/bin/install-nps.sh
  cd
}

function config_app(){
  green "======================="
  blue "Configure app"
  green "======================="
  read -p "Input your usename:   " username 
  read -p "Input your password:   " password
  CONFIG_FILES="authinfo condarc esmtprc fbtermrc getmailrc msmtprc offlineimaprc procmail xinitrc"
  CONFIG_DIRS="calcurse w3m goful"

  cd
  mkdir -p .dotfiles
  for FILE in $CONFIG_FILES
  do
      green "Backup $FILE in .dotfiles for you"
      mv -f ".$FILE" ".dotfiles/$FILE-$(date +%Y%m%d_%s)"

      green "Add new $FILE for you"
      cp "EnvSetup/config/.$FILE" ".$FILE"
      sed -i "s/USERNAME/$username/g" ".$FILE"
      sed -i "s/PASSWORD/$password/g" ".$FILE"
  done

  for DIR in $CONFIG_DIRS
  do
      green "Backup $DIR in .dotfiles for you"
      mv -f ".$FILE" ".dotfiles/$FILE-$(date +%Y%m%d_%s)"
      green "Add new $DIR for you"
      cp -r "EnvSetup/config/.$DIR" ".$DIR"
  done
  cd
}

function config_network(){
  green "======================="
  blue "Configure network"
  green "======================="
  bash ~/EnvSetup/bash/bin/configure-debian-wifi.sh
}

function config_fonts(){
  green "======================="
  blue "Configure fonts"
  green "======================="
  bash ~/EnvSetup/bash/bin/install-fonts.sh
}

function config_locale(){
  bash ~/EnvSetup/bash/bin/configure-locale.sh
}

start_menu(){
  clear
  sleep 2
  option=$(dialog --title " Vps 一键安装自动脚本 2020-2-27 更新 " \
    --checklist "请输入:" 20 70 5 \
    "bash" "Your shell" 0 \
    "vim" "Dark side editor" 0 \
    "emacs" "Another zen editor" 0 \
    "tmux" "Multi screen" 0 \
    "python" "Fast programming language" 0 \
    "nvm" "nvm+npm" 0 \
    "caddy" "Caddy Web Server" 0 \
    "trojan" "Trojan proxy Server" 0 \
    "xray" "xray proxy Server" 0 \
    "nps" "Nps server and client" 0 \
    "fonts" "Popular nerd fonts" 0 \
    "app" "Configure some command tools" 0 \
    "network" "Configure network" 0 \
    "locale" "Configure locale" 0 \
    3>&1 1>&2 2>&3 3>&1)
  green "Your choosed the ${option}"
  sleep 2
  case "$option" in
    bash)
    install_bash
    ;;
    vim)
    install_vim
    ;;
    emacs)
    install_emacs
    ;;
    tmux)
    install_tmux
    ;;
    python)
    install_python
    ;;
    nvm)
    install_nvm
    ;;
    caddy)
    install_caddy
    ;;
    trojan)
    install_trojan
    ;;
    v2ray)
    install_v2ray
    ;;
    nps)
    install_nps
    ;;
    fonts)
    config_fonts
    ;;
    app)
    config_app
    ;;
    network)
    config_network
    ;;
    locale)
    config_locale
    ;;
    *)
    clear
    exit 1
    ;;
  esac
}

check_commands dialog
start_menu

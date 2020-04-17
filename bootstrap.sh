#!/usr/bin/env bash

blue(){
    echo -e "\033[34m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}

function install_vim(){
  green "======================="
  blue "Installing space-vim for you"
  green "======================="
  cd
  sh EnvSetup/bash/bin/vim.sh
  cd
}

function install_bash(){
  green "======================="
  blue "Installing oh-my-bash for you"
  green "======================="
  cd
  sh EnvSetup/bash/bin/bash.sh

  cd
  cat > .bashrc <<-EOF
export OSH=~/.oh-my-bash
OSH_THEME="mairan"
CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"
OSH_CUSTOM=~/EnvSetup/bash/custom
completions=(
  git
  composer
  ssh
  system
)
aliases=(
  general
  vim
)
plugins=(
  git
  emacs
  vim
  bashmarks
)
source \$OSH/oh-my-bash.sh
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
EOF
}

function install_tmux(){
  green "======================="
  blue "Installing oh-my-tmux for you"
  green "======================="
  cd
  sh EnvSetup/bash/bin/tmux.sh
  cd
}

function install_emacs(){
  green "======================="
  blue "Installing doom emacs for you"
  green "======================="
  cd
  sh EnvSetup/bash/bin/emacs.sh
  cd
}


function install_python(){
  green "======================="
  blue "Installing python+pyenv+pipenv+ansible"
  green "======================="
  cd
  sh EnvSetup/bash/bin/python.sh
  cd
}


function install_nvm(){
  green "======================="
  blue "Installing nvm+npm"
  green "======================="
  cd
  sh EnvSetup/bash/bin/nvm.sh
  cd
}

function install_caddy(){
  green "======================="
  blue "Installing caddy"
  green "======================="
  cd
  sh EnvSetup/bash/bin/install-caddy.sh
  cd
}

function install_trojan(){
  green "======================="
  blue "Installing trojan"
  green "======================="
  cd
  sh EnvSetup/bash/bin/install-trojan.sh
  cd
}

function install_v2ray(){
  green "======================="
  blue "Installing v2ray"
  green "======================="
  cd
  sh EnvSetup/bash/bin/install-v2ray.sh
  cd
}


function config_app(){
  green "======================="
  blue "Configure app"
  green "======================="
  read -p "Input your usename:   " username 
  read -p "Input your password:   " password
  CONFIG_FILES="authinfo condarc esmtprc fbtermrc getmailrc msmtprc offlineimaprc procmail xinitrc"

  cd
  for FILE in $CONFIG_FILES
  do
      echo "Backup $FILE in .dotfiles for you"
      mkdir -p .dotfiles
      mv -f ".$FILE" ".dotfiles/$FILE-$(date +%Y%m%d_%s)"

      echo "Add new $FILE for you"
      cp EnvSetup/config/$FILE ".$FILE"
      sed -i "s/USERNAME/$username/g" ".$FILE"
      sed -i "s/PASSWORD/$password/g" ".$FILE"
  done
  cd
}


start_menu(){

  clear
  green " ===================================="
  green " Vps 一键安装自动脚本 2020-2-27 更新 "
  green " 系统：centos7+/debian9+/ubuntu16.04+"
  green " 网站：https://xingwenju.netlify.com"
  green " ===================================="
  echo
  green " 1. vim"
  red " 2. bash"
  green " 3. emacs"
  green " 4. tmux"
  red " 5. python"
  red " 6. nvm+npm"
  red " 7. caddy"
  red " 8. trojan"
  red " 9. v2ray"
  red " 10. config app"
  blue " 0. 退出脚本"
  echo
  read -p "请输入数字:" num
  case "$num" in
  1)
  install_vim
  ;;
  2)
  install_bash
  ;;
  3)
  install_emacs
  ;;
  4)
  install_tmux
  ;;
  5)
  install_python
  ;;
  6)
  install_nvm
  ;;
  7)
  install_caddy
  ;;
  8)
  install_trojan
  ;;
  9)
  install_v2ray
  ;;
  10)
  config_app
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

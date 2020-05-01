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
  bash EnvSetup/bash/bin/vim.sh
  cd
}

function install_bash(){
  green "======================="
  blue "Installing oh-my-bash for you"
  green "======================="
  cd
  bash EnvSetup/bash/bin/bash.sh

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
  fzf
  #nvm
  #go
  #python
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
  bash EnvSetup/bash/bin/tmux.sh
  cd
}

function install_emacs(){
  green "======================="
  blue "Installing doom emacs for you"
  green "======================="
  cd
  bash EnvSetup/bash/bin/emacs.sh
  cd
}


function install_python(){
  green "======================="
  blue "Installing python+pyenv+pipenv+ansible"
  green "======================="
  cd
  bash EnvSetup/bash/bin/python.sh
  cd
}


function install_nvm(){
  green "======================="
  blue "Installing nvm+npm"
  green "======================="
  cd
  bash EnvSetup/bash/bin/nodejs.sh
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

function install_v2ray(){
  green "======================="
  blue "Installing v2ray"
  green "======================="
  cd
  bash EnvSetup/bash/bin/install-v2ray.sh
  cd
}

function install_nps(){
  green "======================="
  blue "Installing v2ray"
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

function config_network(){
  green "======================="
  blue "Configure network"
  green "======================="
  bash ~/EnvSetup/bash/bin/setup-wifi-debian.sh
}

function config_locale(){

  green "Setting the console font"
  sudo sed -i 's/^FONTFACE=.*$/FONTFACE=\"Terminus\"\n/g' /etc/default/console-setup
  sudo sed -i 's/^FONTSIZE=.*$/FONTSIZE=\"12x24\"\n/g' /etc/default/console-setup
  sudo /etc/init.d/console-setup.sh

  green "Setting system locale"
  sudo apt install -y locales-all fbterm
  sudo localectl set-locale LANG="zh_CN.UTF-8" LANGUAGE="zh_CN:zh"
  source /etc/default/locale
  green $LANG
}


start_menu(){

  clear
  num=$(dialog --title " Vps 一键安装自动脚本 2020-2-27 更新 " \
    --checklist "请输入:" 20 70 5 \
    "vim" "Dark side editor" 0 \
    "bash" "Your shell" 0 \
    "emacs" "Another zen editor" 0 \
    "tmux" "Multi screen" 0 \
    "python" "Fast programming language" 0 \
    "nvm" "nvm+npm" 0 \
    "caddy" "Caddy Web Server" 0 \
    "trojan" "Trojan proxy Server" 0 \
    "v2ray" "V2ray proxy Server" 0 \
    "nps" "Nps server and client" 0 \
    "app" "Configure some command tools" 0 \
    "network" "Configure network" 0 \
    "locale" "Configure locale" 0 \
    3>&1 1>&2 2>&3 3>&1)
  green "Your choosed the ${num}"
  case "$num" in
    vim)
    install_vim
    ;;
    bash)
    install_bash
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

if ! command -v "dialog" >/dev/null 2>&1; then
  sudo apt install -y dialog
else
  echo "Dialog installed!"
fi

start_menu

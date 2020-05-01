#!/usr/bin/env bash

green "Setting the console font"
sudo sed -i 's/^FONTFACE=.*$/FONTFACE=\"Terminus\"\n/g' /etc/default/console-setup
sudo sed -i 's/^FONTSIZE=.*$/FONTSIZE=\"12x24\"\n/g' /etc/default/console-setup
sudo /etc/init.d/console-setup.sh restart

green "Setting system locale"
sudo apt install -y locales-all fbterm fonts-wqy-zenhei fonts-wqy-microhei
sudo localectl set-locale LANG="zh_CN.UTF-8" 
sudo localectl set-locale LANGUAGE="zh_CN.UTF-8"
source /etc/default/locale
green $LANG
green $LANGUAGE

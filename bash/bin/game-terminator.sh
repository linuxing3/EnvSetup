#!/usr/bin/env bash

PREFIX="ssh -p 11119 root@xunqinji.top"
TOGGLE_VPS="ssh -p 22 root@xunqinji.top"
TOGGLE_VPS2="ssh -p 22 root@dongxishijie.xyz"

blue() {
	echo -e "\033[34m\033[01m$1\033[0m"
}
green() {
	echo -e "\033[32m\033[01m$1\033[0m"
}
red() {
	echo -e "\033[31m\033[01m$1\033[0m"
}
toggle_item(){
  clear
  option=$(dialog --title "Toggle killers " \
    --checklist "请输入:" 20 70 5 \
    "1" "Allow YoukuDesktop" 0 \
    "2" "Allow MinecraftLauncher.exe" 0 \
    "3" "Allow MinecraftDesktop" 0 \
    "4" "Deny YoukuDesktop" 0 \
    "5" "Deny MinecraftLauncher.exe" 0 \
    "6" "Deny MinecraftDesktop" 0 \
    "7" "Show kids rules" 0 \
    "8" "Start xunqinji proxy" 0 \
    "9" "Stop xunqinji proxy" 0 \
    "10" "Start dongxishijie proxy" 0 \
    "11" "Stop dongxishijie proxy" 0 \
    3>&1 1>&2 2>&3 3>&1)
  echo "Your choosed the ${option}"
  case "$option" in
    1)
    ssh -p 11119 root@xunqinji.top sed -i '2s/^/#/g' /usr/local/bin/game-terminator.sh
    ssh -p 11119 root@xunqinji.top cat /usr/local/bin/game-terminator.sh
    ;;
    2)
    $PREFIX sed -i '3s/^/#/g' /usr/local/bin/game-terminator.sh
    $PREFIX cat /usr/local/bin/game-terminator.sh
    ;;
    3)
    $PREFIX sed -i '4s/^/#/g' /usr/local/bin/game-terminator.sh
    $PREFIX cat /usr/local/bin/game-terminator.sh
    ;;
    4)
    $PREFIX sed -i '2s/#//g' /usr/local/bin/game-terminator.sh
    $PREFIX cat /usr/local/bin/game-terminator.sh
    ;;
    5)
    $PREFIX sed -i '3s/#//g' /usr/local/bin/game-terminator.sh
    $PREFIX cat /usr/local/bin/game-terminator.sh
    ;;
    6)
    $PREFIX sed -i '4s/#//g' /usr/local/bin/game-terminator.sh
    $PREFIX cat /usr/local/bin/game-terminator.sh
    ;;
    7)
    $PREFIX cat /usr/local/bin/game-terminator.sh
    ;;
    8)
    $TOGGLE_VPS systemctl start trojan
    $TOGGLE_VPS systemctl start v2ray
    $TOGGLE_VPS systemctl status trojan
    $TOGGLE_VPS systemctl status v2ray
    ;;
    9)
    $TOGGLE_VPS systemctl stop trojan
    $TOGGLE_VPS systemctl stop v2ray
    $TOGGLE_VPS systemctl status trojan
    ;;
    10)
    $TOGGLE_VPS2 systemctl start trojan
    $TOGGLE_VPS2 systemctl start v2ray
    $TOGGLE_VPS2 systemctl status trojan
    $TOGGLE_VPS2 systemctl status v2ray
    ;;
    11)
    $TOGGLE_VPS2 systemctl stop trojan
    $TOGGLE_VPS2 systemctl stop v2ray
    $TOGGLE_VPS2 systemctl status trojan
    $TOGGLE_VPS2 systemctl status v2ray
    ;;
    *)
    clear
    exit 1
    ;;
  esac
}

create_script() {
  sudo touch /usr/local/bin/game-terminator 
  sudo chmod +x /usr/local/bin/game-terminator 
  cat >> /usr/local/bin/game-terminator < EOF
/mnt/c/npc/nircmd.exe infobox "Stopping Games and Videos" "Hello, Daniel"                                                                                                     
taskkill.exe /IM YoukuDesktop.exe /F                                                                                                                                           
taskkill.exe /IM MinecraftLauncher.exe /F                                                                                                                                      
taskkill.exe /IM Minecraft.Windows.exe /F 
EOF
}

echo "Toggle killing apps"
toggle_item

#!/usr/bin/env bash

XIAORUI="ssh -p 11119 root@xunqinji.top"
VPS1="ssh -p 22 root@xunqinji.top"
VPS2="ssh -p 22 root@dongxishijie.xyz"
NIRCMD="/mnt/c/npc/nircmd.exe" 
SCRIPT1="/usr/local/bin/game-terminator.sh"

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
    "12" "Warning with text" 0 \
    "13" "Warning with voice" 0 \
    "14" "Playing a music" 0 \
    3>&1 1>&2 2>&3 3>&1)
  echo "Your choosed the ${option}"
  case "$option" in
    1)
    $XIAORUI sed -i '2s/^/#/g' $SCRIPT1
    $XIAORUI cat $SCRIPT1
    ;;
    2)
    $XIAORUI sed -i '3s/^/#/g' $SCRIPT1
    $XIAORUI cat $SCRIPT1
    ;;
    3)
    $XIAORUI sed -i '4s/^/#/g' $SCRIPT1
    $XIAORUI cat $SCRIPT1
    ;;
    4)
    $XIAORUI sed -i '2s/#//g' $SCRIPT1
    $XIAORUI cat $SCRIPT1
    ;;
    5)
    $XIAORUI sed -i '3s/#//g' $SCRIPT1
    $XIAORUI cat $SCRIPT1
    ;;
    6)
    $XIAORUI sed -i '4s/#//g' $SCRIPT1
    $XIAORUI cat $SCRIPT1
    ;;
    7)
    $XIAORUI cat $SCRIPT1
    ;;
    8)
    $VPS1 systemctl start trojan
    $VPS1 systemctl start v2ray
    $VPS1 systemctl status trojan
    $VPS1 systemctl status v2ray
    ;;
    9)
    $VPS1 systemctl stop trojan
    $VPS1 systemctl stop v2ray
    $VPS1 systemctl status trojan
    $VPS1 systemctl status v2ray
    ;;
    10)
    $VPS2 systemctl start trojan
    $VPS2 systemctl start v2ray
    $VPS2 systemctl status trojan
    $VPS2 systemctl status v2ray
    ;;
    11)
    $VPS2 systemctl stop trojan
    $VPS2 systemctl stop v2ray
    $VPS2 systemctl status trojan
    $VPS2 systemctl status v2ray
    ;;
    12)
    $XIAORUI $NIRCMD infobox "Stopping games and videos" "[Daniel] :(" 
    ;;
    13)
    $XIAORUI $NIRCMD speak text "Daniel please stop playing games and videos in morning" 0 100
    ;;
    14)
    $XIAORUI $NIRCMD mediaplay 10000 "c:\\npc\\1.mp3"
    ;;
    *)
    clear
    exit 1
    ;;
  esac
}

create_script() {
  sudo touch $SCRIPT1 
  sudo chmod +x $SCRIPT1
  cat >> $SCRIPT1 < EOF
/mnt/c/npc/nircmd.exe infobox "Stopping Games and Videos" "Hello, Daniel"                                                                                                     
taskkill.exe /IM YoukuDesktop.exe /F                                                                                                                                           
taskkill.exe /IM MinecraftLauncher.exe /F                                                                                                                                      
taskkill.exe /IM Minecraft.Windows.exe /F 
EOF
}

toggle_item

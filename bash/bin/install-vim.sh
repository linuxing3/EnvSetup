#=============================================================================
# install-vim.sh --- bootstrap script for Vim
# Copyright (c) 2016-2017 Linuxing3 & Contributors
# Author: Linuxing3 
# License: GPLv3
#=============================================================================

echo "==========================================================="
echo "vim, one of the best editors"
echo "==========================================================="

sudo apt-get install -y vim

option=$(dialog --title " Spacevim 一键安装自动脚本" \
  --checklist "请输入:" 20 70 5 \
  "1" "SpaceVim, Dark side editor" 0 \
  "2" "space-vim, yet another dist" 0 \
  3>&1 1>&2 2>&3 3>&1)

cd
cp .vimrc .vimrc.old

case "$option" in
  1)
  curl -fsSL https://spacevim.org/install.sh | bash
  ;;
  2)
  curl -fsSL https://raw.githubusercontent.com/liuchengxu/space-vim/master/install.sh | bash
  ;;
  *)
  echo "Skipped!"
esac


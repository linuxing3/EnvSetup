#!/usr/bin/env bash

version=$(dpkg --print-architecture)

echo "==========================================================="
echo "installing oh-my-bash"
echo "==========================================================="
cd
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

cp .bashrc .bashrc.backup
cp EnvSetup/bash/bashrc.default .bashrc

install_others() {
  echo "==========================================================="
  echo "others: like prettyping"
  echo "==========================================================="
  echo "wget https://raw.githubusercontent.com/denilsonsa/prettyping/master/prettyping"
  echo "mv prettyping envsetup/bash/bin/"
  echo "chmod +x envsetup/bash/bin/prettyping"

  echo "==========================================================="
  echo "others: like taskbook"
  echo "==========================================================="
  echo "npm install --global taskbook"
}

install_bat() {
  echo "==========================================================="
  echo "Install bat, Another cat"
  echo "==========================================================="
  wget https://github.com/sharkdp/bat/releases/download/v0.13.0/bat_0.13.0_${version}.deb
  sudo dpkg -i bat_0.13.0_${version}.deb
  rm bat_0.13.0_${version}*.deb
}

install_wtf() {
  echo "==========================================================="
  echo "Install wtf, personal information dashboard"
  echo "==========================================================="
  file=wtf_0.35.0_linux_${version}
  wget https://github.com/wtfutil/wtf/releases/download/v0.35.0/${file}.tar.gz
  tar -xvf ${file}.tar.gz
  chmod +x ${file}/wtfutil
  mv ${file}/wtfutil /usr/local/bin/
  rm -rf $file
  rm $file.tar.gz
}

start_menu() {
	PS3='Please enter your choice: '
	select opt in "Install" "Extra" "bash-it" "Skip"; do
	    case $opt in
	        bash-it)
	        echo "==========================================================="
	        echo "installing bash-it"
	        echo "==========================================================="
	        cd
	        if [[ ! -d ~/workspace/bash-it ]]; then
	          mkdir -p ~/workspace/bash-it
	          cd ~/workspace/bash-it
	          git clone https://github.com/Bash-it/bash-it .
	        fi
	        break
	        ;;

	        Install)
	        cd
	        tools=$(dialog --title " Bash extra tools 安装自动脚本" \
	          --checklist "请输入:" 20 70 5 \
	          "ncdu" "Disk usage" 0 \
	          "htop" "Process Monitor" 0 \
	          "fd-find" "Better finder" 0 \
	          "fzf" "Better search" 0 \
	          "fd" "Other Finder" 0 \
	          "exa" "Better ls " 0 \
	          "jed" "Another editor " 0 \
	          "rip-grep" "Better grep" 0 \
	          3>&1 1>&2 2>&3 3>&1)
	        for tool in $tools
	        do
	          sudo apt install $tool -y
	        done
	        break
	        ;;

	        Extra)
	        cd
	        go install github.com/linuxing3/goful@latest
	        install_bat
	        install_wtf
	        echo "Install startship, cross shell prompts"
	        curl -fsSL https://starship.rs/install.sh | bash
	        cd
	        break
	        ;;

	        Skip)
	        echo "Skipped installing additional tools"
	        break
	        ;;
	        *)
	        echo "Quit"
	        break
	        ;;
	    esac
	done
}

start_menu

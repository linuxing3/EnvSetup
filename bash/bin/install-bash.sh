#!/usr/bin/env bash

echo "==========================================================="
echo "installing oh-my-bash"
echo "==========================================================="
cd
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

PS3='Please enter your choice: '
select opt in "Install" "Skip"; do
    case $opt in
        "Install")
        echo "==========================================================="
        echo "installing bash-it"
        echo "==========================================================="
        if [[ ! -d ~/workspace/bash-it ]]; then
          mkdir -p ~/workspace/bash-it
          cd ~/workspace/bash-it
          git clone https://github.com/Bash-it/bash-it .
        fi
        cd

        tools=$(dialog --title " Bash extra tools 安装自动脚本" \
          --checklist "请输入:" 20 70 5 \
          "ncdu" "Disk usage" 0 \
          "htop" "Process Monitor" 0 \
          "fd-find" "Better finder" 0 \
          "fd" "Other Finder" 0 \
          "rip-grep" "Better grep" 0 \
          3>&1 1>&2 2>&3 3>&1)
        for tool in $tools
        do
          sudo apt install $tool -y
        done

        echo "==========================================================="
        echo "Others: like bat"
        echo "==========================================================="
        version=$(dpkg --print-architecture)
        wget https://github.com/sharkdp/bat/releases/download/v0.13.0/bat_0.13.0_${version}.deb
        sudo dpkg -i bat_0.13.0_${version}.deb
        rm bat_0.13.0_${version}*.deb

        echo "==========================================================="
        echo "Others: like prettyping"
        echo "==========================================================="
        echo "wget https://raw.githubusercontent.com/denilsonsa/prettyping/master/prettyping"
        echo "mv prettyping EnvSetup/bash/bin/"
        echo "chmod +x EnvSetup/bash/bin/prettyping"

        echo "==========================================================="
        echo "Others: like taskbook"
        echo "==========================================================="
        echo "npm install --global taskbook"
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

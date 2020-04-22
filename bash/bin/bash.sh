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
        mkdir -p ~/workspace
        cd ~/workspace
        git clone https://github.com/Bash-it/bash-it
        cd

        echo "==========================================================="
        echo "installing ncdu htop fd-find rip-grep bat prettyping"
        echo "==========================================================="
        sudo apt install ncdu -y
        sudo apt install htop -y
        sudo apt install fd-find fd -y
        sudo apt install rip-grep -y

        version=$(dpkg --print-architecture)
        wget https://github.com/sharkdp/bat/releases/download/v0.13.0/bat_0.13.0_${version}.deb
        sudo dpkg -i bat_0.13.0_${version}.deb
        rm bat_0.13.0_${version}*.deb

        echo "wget https://raw.githubusercontent.com/denilsonsa/prettyping/master/prettyping"
        echo "mv prettyping EnvSetup/bash/bin/"
        echo "chmod +x EnvSetup/bash/bin/prettyping"

        echo "==========================================================="
        echo "Others: like taskbook"
        echo "==========================================================="
        echo "npm install --global taskbook"
        break
        ;;
        *)
        echo "Skipped installing additional tools"
        break
        ;;
        *)
        echo "Quit"
        break
        ;;
    esac
done

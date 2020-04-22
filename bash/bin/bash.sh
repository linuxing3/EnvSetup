#!/usr/bin/env bash

echo "==========================================================="
echo "installing oh-my-bash"
echo "==========================================================="
cd
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

PS3='Please enter your choice: '
select opt in "y" "n"; do
    case $opt in
        "y")
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
        sudo apt install ncdu
        sudo apt install htop
        sudo apt install fd-find
        sudo apt install rip-grep

        version=$(dpkg --print-architecture)
        wget https://github.com/sharkdp/bat/releases/download/v0.13.0/bat_0.13.0_${version}.deb
        sudo dpkg -i bat_0.13.0_${version}.deb
        rm bat_0.13.0_i386*.deb

        wget https://raw.githubusercontent.com/denilsonsa/prettyping/master/prettyping
        mv prettyping EnvSetup/bash/bin/
        chmod +x EnvSetup/bash/bin/prettyping

        echo "==========================================================="
        echo "Others: like taskbook"
        echo "==========================================================="
        echo "npm install --global taskbook"
        break
        ;;
        *) 
        echo "Skipped installing additional tools" 
        break;
        ;;
    esac
done

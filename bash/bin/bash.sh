echo "==========================================================="
echo "installing oh-my-bash"
echo "==========================================================="
cd
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

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

wget https://github.com/sharkdp/bat/releases/download/v0.13.0/bat_0.13.0_i386.deb
sudo dpkg -i bat_0.13.0_i386.deb 
rm bat_0.13.0_i386.deb 

wget https://raw.githubusercontent.com/denilsonsa/prettyping/master/prettyping
mv prettyping EnvSetup/bash/bin/
chmod +x EnvSetup/bash/bin/prettyping

echo "==========================================================="
echo "Others: like taskbook"
echo "==========================================================="
echo "npm install --global taskbook"

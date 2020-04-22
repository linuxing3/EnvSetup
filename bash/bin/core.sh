echo "==========================================================="
echo "update packages"
echo "==========================================================="

echo "Install core tools"
sudo apt-get -y update
sudo apt-get install -y tmux
sudo apt-get install -y git
sudo apt-get install -y wget curl elinks
sudo apt-get install -y bash bat fg

echo "Install build tools"
sudo apt-get install -y build-essential
sudo apt-get install -y python3 python3-pip
sudo apt-get install -y g++ make
sudo apt-get install -y libcairo2-dev nfs-common portmap

sudo apt install fd-find
sudo apt install bat
wget https://github.com/sharkdp/bat/releases/download/v0.13.0/bat_0.13.0_i386.deb
sudo dpkg -i bat_0.13.0_i386.deb 

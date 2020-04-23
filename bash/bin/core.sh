echo "==========================================================="
echo "update packages"
echo "==========================================================="

echo "Install core tools"
sudo apt-get -y update

sudo apt-get install -y git
sudo apt-get install -y tmux screen fbterm
sudo apt-get install -y wget curl httpie elinks lynx w3m calcurse
sudo apt-get install -y bash zsh screenfetch cowsay 

echo "Install build tools"
sudo apt-get install -y python3 python3-pip python-apt python-venv
sudo apt-get install -y build-essential
sudo apt-get install -y g++ make
sudo apt-get install -y libcairo2-dev nfs-common portmap

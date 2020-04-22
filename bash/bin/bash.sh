echo "==========================================================="
echo "installing oh-my-bash"
echo "==========================================================="
# using oh-my-bash
cd
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

echo "==========================================================="
echo "installing bash-it"
echo "==========================================================="
mkdir -p ~/workspace
cd ~/workspace
git clone https://github.com/Bash-it/bash-it
cd

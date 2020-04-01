echo "==========================================================="
echo "installing python3"
echo "==========================================================="

sudo apt-get install -y python3 python3-pip python3-apt
sudo apt-get install -y libreadline-dev libssh-dev libbz2-dev

# Make sure to use python 3
sudo rm /usr/bin/python
sudo ln -s /usr/bin/python3 /usr/bin/python
sudo rm /usr/bin/pip
sudo ln -s /usr/bin/pip3 /usr/bin/pip

cd
# using pyenv
pip3 install --user --no-warn-script-location pyenv
echo "export PATH=$PATH:/home/vagrant/.pyenv/bin" >> /home/vagrant/.bashrc

# using ansible
pip3 install --user --no-warn-script-location ansible
# using pipenv
pip3 install --user --no-warn-script-location pipenv

echo "export PATH=$PATH:/home/vagrant/.local/bin" >> /home/vagrant/.bashrc

source /home/vagrant/.bashrc

echo "==========================================================="
echo "python"
echo "==========================================================="

sudo apt-get install -y python3 python3-pip python3-apt
sudo apt-get install -y libreadline-dev libssh-dev libbz2-dev

echo "python 3"
sudo rm /usr/bin/python
sudo ln -s /usr/bin/python3 /usr/bin/python
sudo rm /usr/bin/pip
sudo ln -s /usr/bin/pip3 /usr/bin/pip

cd
echo "pyenv"
curl https://pyenv.run | bash
echo "==========================================================="
echo "anaconda"
echo "pyenv install anaconda3-5.3.1"

echo "ansible"
echo "==========================================================="
pip3 install --user --no-warn-script-location ansible

echo "pipenv"
echo "==========================================================="
pip3 install --user --no-warn-script-location pipenv

echo "pipenv"
echo "==========================================================="
pip3 install --user --no-warn-script-location virtualenv virtualenvwrapper

echo "==========================================================="
echo "pyenv"
echo "export PATH=$HOME/.local/bin:$HOME/.pyenv/bin:$PATH" >> $HOME/.bashrc
echo "==========================================================="

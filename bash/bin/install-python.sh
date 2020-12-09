echo "==========================================================="
echo "安装python开发系统"
echo "==========================================================="

sudo apt-get install -y python3 python3-pip python3-apt
sudo apt-get install -y libreadline-dev libssh-dev libbz2-dev

echo "确保使用python 3 版本"
sudo rm /usr/bin/python
sudo ln -s /usr/bin/python3 /usr/bin/python
sudo rm /usr/bin/pip
sudo ln -s /usr/bin/pip3 /usr/bin/pip

cd
echo "安装pyenv"
curl https://pyenv.run | bash
echo "==========================================================="
echo "如果需要完整功能，请安装anaconda套件"
echo "pyenv install anaconda3-5.3.1"

echo "安装ansible"
echo "==========================================================="
pip3 install --user --no-warn-script-location ansible

echo "安装pipenv"
echo "==========================================================="
pip3 install --user --no-warn-script-location pipenv

echo "安装pipenv"
echo "==========================================================="
pip3 install --user --no-warn-script-location virtualenv virtualenvwrapper

echo "==========================================================="
echo "如果无法找到pyenv等，请添加路径"
echo "export PATH=$HOME/.local/bin:$HOME/.pyenv/bin:$PATH" >> $HOME/.bashrc
echo "==========================================================="

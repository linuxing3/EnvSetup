echo "==========================================================="
echo "��װpython����ϵͳ"
echo "==========================================================="

sudo apt-get install -y python3 python3-pip python3-apt
sudo apt-get install -y libreadline-dev libssh-dev libbz2-dev

echo "ȷ��ʹ��python 3 �汾"
sudo rm /usr/bin/python
sudo ln -s /usr/bin/python3 /usr/bin/python
sudo rm /usr/bin/pip
sudo ln -s /usr/bin/pip3 /usr/bin/pip

cd
echo "��װpyenv"
curl https://pyenv.run | bash
echo "==========================================================="
echo "�����Ҫ�������ܣ��밲װanaconda�׼�"
echo "pyenv install anaconda3-5.3.1"

echo "��װansible"
echo "==========================================================="
pip3 install --user --no-warn-script-location ansible

echo "��װpipenv"
echo "==========================================================="
pip3 install --user --no-warn-script-location pipenv

echo "��װpipenv"
echo "==========================================================="
pip3 install --user --no-warn-script-location virtualenv virtualenvwrapper

echo "==========================================================="
echo "����޷��ҵ�pyenv�ȣ������·��"
echo "export PATH=$HOME/.local/bin:$HOME/.pyenv/bin:$PATH" >> $HOME/.bashrc
echo "==========================================================="

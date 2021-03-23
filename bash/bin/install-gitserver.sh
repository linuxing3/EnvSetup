echo creating an admin account:
echo 1) Install git-core
echo sudo apt-get install git-core

echo 2) create git master firectory, using --bare for not directly editable
sudo mkdir -p /opt/git/directory.git
cd /opt/git/directory.git
sudo git init --bare /opt/git/directory.git

echo 3) create group gitgroup make directory.git 
echo and its sub-directories write permission by gitgroup 
sudo groupadd gitgroup
sudo chmod -R g+ws *
sudo chgrp -R gitgroup *

echo4) Set sharedRepository true
sudo git config core.sharedRepository true

echo5) For test purpose, create new user xing and assign him to group gitgroup:
sudo adduser xing
sudo groupadd gitgroup
sudo usermod -G gitgroup xing

echo 
echo Now in xing account (normal user account):

echo 1) set name and email for git
echo git config --global user.email "linuxing3@qq.com"
echo git config --global user.name "linuxing3"

echo 2) Clone from master, change 192.168.1.80 to your git server IP, a newdirectory /home/xing/directory will be created

echo git clone xing@192.168.1.80:/opt/git/directory.git

echo 3)Create a new file README under directory and commit it
echo cd directory
echo vim README
echo git add README
echo git commit -am 'fix for the README file by xing'

echo 4) push to server
echo git push origin master

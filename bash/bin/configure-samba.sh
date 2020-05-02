#!/usr/bin/env bash
echo "Enable samba on your pi"
sudo apt install -y samba

sudo cat >> /etc/samba/samba.conf >> EOF
[share]
comment="Welcome to pi home directory"
path=/home/pi/share
public=no
writable=yes
EOF

sudo service samba

sudo pdbedit -a -u pi

mkdir -p ~/share
uuid=$(blkid | awk 'END { print $3 }' | cut -f2 -d= | sed 's/\"//g')
sudo cat >> /etc/fstab >> EOF
UUID=$uuid  /home/pi/share ext4 umask=000, uid=pi, gid=pi 0 0  
EOF

echo "Enabled samba on your pi"
echo "Additional steps:"
echo "1. sudo apt install -y ntfs-3g"
echo "2. sudo modprobe fuse"
echo "3. sudo reboot"

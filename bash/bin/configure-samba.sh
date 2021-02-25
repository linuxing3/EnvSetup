#!/usr/bin/env bash
echo "Enable samba on your pi"
sudo apt install -y samba

echo "Enable share folder in home directory"
mkdir -p ~/share
sudo cat >> /etc/samba/smb.conf >> EOF
[share]
comment="Welcome to pi home directory"
path=/home/pi/share
[sda1]
comment="ext hdd sda1"
path=/mnt/sda1/share
[sda2]
comment="ext hdd sda2 xing"
path=/mnt/sda2/home/xing
EOF

sudo service samba
sudo pdbedit -a -u pi

# uuid=$(sudo blkid | awk 'END { print $3 }' | cut -f2 -d= | sed 's/\"//g')
sudo cat >> /etc/fstab >> EOF
# main passport
PARTUUID="89147e32-01" /mnt/sda1 ntfs auto,exec,rw,user,dmask=002,fmask=113,uid=1000,gid=1000 0 0                                                                                           
PARTUUID="89147e32-02" /mnt/sda2 ext4   defaults,auto,users,rw,nofail   0       0
PARTUUID="89147e32-03" /mnt/sda3 ntfs auto,exec,rw,user,dmask=002,fmaks=113,uid=1000,gid=1000 0 0                                                                                           
# ipod
PARTUUID="b2d61d33-01" /mnt/sdb1 ext4   defaults,auto,users,rw,nofail   0       0
PARTUUID="b2d61d33-02" /mnt/sdb2 ext4   defaults,auto,users,rw,nofail   0       0
PARTUUID="b2d61d33-03" /mnt/sdb3 ext4   defaults,auto,users,rw,nofail   0       0
PARTUUID="b2d61d33-04" /mnt/sdb4 ext4   defaults,auto,users,rw,nofail   0       0
EOF

echo "Enabled samba on your pi"
echo "Additional steps:"
echo "1. sudo apt install -y ntfs-3g"
echo "2. sudo modprobe fuse"
echo "3. sudo reboot"

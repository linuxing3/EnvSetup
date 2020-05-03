## This script is inspired by project veewee(https://github.com/jedi4ever/veewee/)
## see https://github.com/jedi4ever/veewee/blob/master/templates/ubuntu-12.04.2-server-amd64/cleanup.sh
## and https://github.com/jedi4ever/veewee/blob/master/templates/ubuntu-12.04.2-server-amd64/zerodisk.sh
## Maybe later, this clean script will also convert to a small ansible playbook.

# Remove items used for building, since they aren't needed anymore

apt-get -y remove linux-headers-$(uname -r) build-essential
apt-get -y autoremove
apt-get -y clean

#Clean up tmp
rm -rf /tmp/*

# Removing leftover leases and persistent rules
echo "cleaning up dhcp leases"
rm /var/lib/dhcp/*

# Make sure Udev doesn't block our network
# http://6.ptmc.org/?p=164
echo "cleaning up udev rules"
rm /etc/udev/rules.d/70-persistent-net.rules
mkdir /etc/udev/rules.d/70-persistent-net.rules
rm -rf /dev/.udev/
rm /lib/udev/rules.d/75-persistent-net-generator.rules

# echo "Adding a 2 sec delay to the interface up, to make the dhclient happy"
# echo "pre-up sleep 2" >> /etc/network/interfaces
# exit

# Zero out the free space to save space in the final image:
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# clean pip cache
rm -rf /var/cache/pip

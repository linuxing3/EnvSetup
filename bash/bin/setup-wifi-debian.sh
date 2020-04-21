ip link set wlp5s0 up

cat << EOF >> /etc/network/interfaces

auto wlp5s0
iface wlp5s0 inet dhcp
pre-up ip link set wlp5s0 up
pre-up iwconfig wlp5s0 essid ssid
wpa-ssid dulce
wpa-psk 20dulce17
EOF

ifup wlp5s0
#1587430788
vim .bash_history 

#! /usr/bin/env bash

ip link set wlp5s0 up

cat << EOF >> /etc/network/interfaces

auto wlp5s0
iface wlp5s0 inet static
address 192.168.1.166
netmask 255.255.255.0
gateway 192.168.1.1
nameserver 80.80.80.80, 80.80.81.81
pre-up ip link set wlp5s0 up
pre-up iwconfig wlp5s0 essid ssid
wpa-ssid dulce
wpa-psk 20dulce17
EOF

ifup wlp5s0

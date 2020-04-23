#!/bin/sh

apt-get install pptpd

echo "localip 10.0.0.1" >> /etc/pptpd.conf 
echo "remoteip 10.0.0.100-200" >> /etc/pptpd.conf 

echo "xing pptpd 20090909 *" >> /etc/ppp/chap-secrets 

echo "ms-dns 8.8.8.8" >> /etc/ppp/pptpd-options
echo "ms-dns 8.8.4.4" >> /etc/ppp/pptpd-options

echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p

iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables --table nat --append POSTROUTING --out-interface ppp0 -j MASQUERADE
iptables -I INPUT -s 10.0.0.0/8 -i ppp0 -j ACCEPT
iptables --append FORWARD --in-interface eth0 -j ACCEPT
iptables-save

service pptpd restart

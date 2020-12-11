echo "Configure your network and routing"

# All request to 192.168.1.0/24 throught xiaomi router
# configure caracas office windows system
#
# for windows
# 10.10.49.41 as gateway in desktop lan ip
# 10.10.49.48 is xiaomi router with 192.168.1.1 for private lan
# 192.168.1.2 is a soft router with laptop
# visita 192.168.1.0/8 by 10.10.49.48

route add -net 192.168.1.0 netmask 255.255.255.0 gateway 10.10.49.48

# for linux 
# ifconfig enp0s3 down
# ip route add 192.168.1.0/24 gateway 10.10.49.48 dev enp0s3
# ifconfig enp0s3 up
#echo "Done!"

echo "Configure your network and routing"

ifconfig enp0s3 down

# All request to 192.168.1.0/24 throught xiaomi router

ip route add 192.168.1.0/24 gateway 10.10.49.48 dev enp0s3

ifconfig enp0s3 up

echo "Done!"

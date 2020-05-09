mkdir ~/.config/aria
touch ~/.config/aria/aria2.session
touch ~/.config/aria/aria2.conf

echo making config file
cat > ~/.config/aria/aria2.conf << EOF
dir=/Volumes/caption/Users/shared/downloads/
disable-ipv6=true
enable-rpc=true
rpc-allow-origin-all=true
rpc-listen-all=true
rpc-listen-port=6800
continue=true
input-file=~/.config/aria/aria2.session
save-session=~/.config/aria/aria2.session
max-concurrent-downloads=3
EOF

echo Starting you aria2c server
aria2c --conf-path=~/.config/aria/aria2.conf -D

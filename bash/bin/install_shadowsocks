echo -----------------------------------
echo install cow and shadowsocks first
echo pip install shadowsocks
echo pip list
echo curl -L git.io/cow | bash
echo which cow
echo
echo -----------------------------------
echo settings in ~/.cow/rc
echo -----------------------------------
echo listen = http://server:7777
echo proxy = ss://aes-256-cfb:password@server:1080
echo -----------------------------------
echo settings in /etc/shadowsocks.json
echo -----------------------------------
echo 
echo {
echo     "server":"server",
echo     "server_port":"1080",
echo     "local_address":"127.0.0.1",
echo     "local_port":"1080",
echo     "password":"password",
echo     "timeout":"300",
echo     "method":"aes-256-cfb",
echo     "fast_open":false,
echo     "workers":1
echo }
echo
echo -----------------------------------
echo starting shadowsocks server on 1080
echo -----------------------------------
nohup ssserver -c /etc/shadowsocks.json&
echo -----------------------------------
echo starting cow proxy on 7777
echo your sserver is
echo ss://aes-256-cfb:20090909@localhost:1080
echo -----------------------------------
echo please put it in you cow configuration file
echo -----------------------------------
cow &
echo -----------------------------------
echo Please connect to http://localhost:7777
echo [http]7777 -----> [socks]1080
echo Enjoy!

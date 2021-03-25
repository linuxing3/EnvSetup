echo ------------------------------------------
echo Making changes to ~/.ssh/config
rm ~/.ssh/config

echo DynamicForward 1080 >> ~/.ssh/config

echo 'ProxyCommand proxytunnel -v -p proxy.mfa.gov.cn:80 -d %h:%p -H "User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Win32)\n"' >> ~/.ssh/config

echo ServerAliveInterval 30 >> ~/.ssh/config

echo Done editing proxytunnel config file

echo Start a tunnel through local net proxy to server 443 port

echo ------------------------------------------
# proxytunnel -v -p 192.168.5.55:80 -d 192.241.206.203:443
echo Connecting to 443 port

echo ------------------------------------------
ssh -p 443 root@xunqinji.xyz

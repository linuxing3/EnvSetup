docker run -d --restart=unless-stopped -e DOMAIN=xunqinji.xyz -e PASSWD="mm123456"-v /root/EnvSetup/trojan/docker:/root/conf -p 4433:4434 -name trojan lihaixin/trojan-docker


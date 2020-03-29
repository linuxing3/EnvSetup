docker run -d --restart=unless-stopped -e DOMAIN=dongxishijie.xyz -e PASSWD="mm123456 user2"-v /root/EnvSetup/trojan:/root/conf -p 443:443 -p 80:80 --name trojan lihaixin/trojan-docker


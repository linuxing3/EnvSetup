
basedir=~/EnvSetup/config/nextcloud/docker-compose/with-nginx-proxy-self-signed-ssl/mariadb/fpm
conffile=$basedir/docker-compose.yml

cd $basedir

sed -i 's/dongxishijie\.xyz/xunqinji\.top/g' $conffile

sed -i 's/- certs:/- \/etc\/xunqinji\.top_ecc:/g' $conffile

sed -i 's/my@example/xingwenju@gmail/g' $conffile

sed -i 's/servhostname\.local/xunqinji.top/g' $conffile

cat $conffile | more
# docker-compose up -d

export CODENAME=`lsb_release -cs`
echo "deb https://download.rethinkdb.com/debian-$CODENAME $CODENAME main" | sudo tee /etc/apt/sources.list.d/rethinkdb.list
wget -qO- https://download.rethinkdb.com/repository/raw/pubkey.gpg | sudo apt-key add -
sudo apt-get update
sudo apt-get install rethinkdb
[?12l[?25h[31;1H[?1049l[23;0;0t[?1l>
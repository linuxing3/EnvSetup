#!/bin/bash

cd /tmp

# install unzip just in case the user doesn't already have it.
sudo apt-get install unzip -y
wget "https://github.com/IBM/type/archive/master.zip"

unzip master.zip
rm master.zip

cd type-master

sudo mkdir -p /usr/share/fonts/truetype/ibm-plex
sudo mkdir -p /usr/share/fonts/opentype/ibm-plex

sudo cp /tmp/type-master/fonts/*/desktop/pc/*.ttf /usr/share/fonts/truetype/ibm-plex/.
sudo cp /tmp/type-master/fonts/*/desktop/mac/*.otf /usr/share/fonts/opentype/ibm-plex/.

sudo fc-cache -fv

git clone "https://github.com/ryanoasis/nerd-fonts"
cd nerd-fonts
./install hack-nerd

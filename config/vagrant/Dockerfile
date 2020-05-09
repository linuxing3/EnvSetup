FROM debian:10.3-slim

WORKDIR /home/vagrant

RUN useradd vagrant -p 20090909 -m -g root -d /home/vagrant
RUN apt update && apt upgrade
RUN apt install -y wget git sudo ruby python
RUN apt install -y gnupg gnupg2 gnupg1
RUN wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
RUN echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian bionic contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
RUN apt update
RUN apt install -y virtualbox-6.0

RUN wget https://download.virtualbox.org/virtualbox/6.0.10/Oracle_VM_VirtualBox_Extension_Pack-6.0.10.vbox-extpack
RUN VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-6.0.10.vbox-extpack

RUN curl -O https://releases.hashicorp.com/vagrant/2.2.6/vagrant_2.2.6_x86_64.deb
RUN apt install -y  ./vagrant_2.2.6_x86_64.deb
RUN mkdir -p /home/vagrant/alpine
RUN chown vagrant:vagrant /home/vagrant/alpine
RUN chmod -R 755 /home/vagrant/alpine
RUN vagrant box add alpine/alpine64

COPY Vagrantfile /home/vagrant/alpine/Vagrantfile
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

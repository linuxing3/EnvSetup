FROM debian:10.3-slim

WORKDIR /home/vagrant

RUN apt update && apt-upgrade
RUN apt install -y bash emacs-nox curl git wget tmux tar unzip fd-find rip-grep ranger
RUN useradd vagrant -p 20090909 -m -g root -d /home/vagrant
RUN cd /home/vagrant && git clone https://github.com/hlissner/doom-emacs .emacs.d
RUN cd .emacs.d/bin && ./doom install
    
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

FROM debian:10.3-slim

WORKDIR /home/vagrant

RUN useradd vagrant -p 20090909 -m -g root -d /home/vagrant
RUN apt update && apt upgrade -y
RUN apt install -y bash emacs-nox curl git wget tmux tar unzip fd-find ripgrep ranger sudo

RUN git clone https://github.com/hlissner/doom-emacs /home/vagrant/.emacs.d
RUN cd /home/vagrant/.emacs.d/bin && sudo -u vagrant ./doom install
    
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

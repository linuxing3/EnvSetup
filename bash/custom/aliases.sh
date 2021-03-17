#!/usr/bin/env bash
# linuxing's Bash Aliases Script 
# by linuxing3 <linuxing3@qq.com>
# License: GNU GPLv3
#
#                                        _
#    ___ _ __   __ _  ___ ___     __   _(_) 
#   / __| -_ \ / _- |/ __/ _ \____\ \ / 
#   \__ \ |_) | (_| | (_|  __/_____\ V /
#   |___/ .__/ \__._|\___\___|      \_/ 
#       |_|
#
#
# if user is not root, pass all commands via sudo #
if [ $UID -ne 0 ]; then
  alias reboot='sudo reboot'
  alias update='sudo apt-get upgrade'
  alias apt='sudo apt-get'
  alias docker='sudo docker'
  alias systemctl='sudo systemctl'
  alias service='sudo service'
fi
#
alias c='clear'
# 
alias ll='ls -la'
# 
alias l.='ls -d .*'
if [ "$(command -v exa)" ]; then
    unalias -m 'll'
    unalias -m 'l'
    unalias -m 'la'
    unalias -m 'ls'
    alias ls='exa -G  --color auto --icons -a -s type'
    alias ll='exa -l --color always --icons -a -s type'
fi

if [ "$(command -v bat)" ]; then
  alias cat='bat'
fi

if [ "$(command -v fd)" ]; then
  alias find='fd'
fi

if [ "$(command -v rg)" ]; then
  alias grep='rg'
fi

if [ "$(command -v ranger)" ]; then
  alias finder='ranger'
  alias explorer='ranger'
fi

## a quick way to get out of current directory ##
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

#
##5: Create parent directories on demand
#
alias mkdir='mkdir -pv'
#
##6: Colorize diff output
#
##7: Make mount command output pretty and human readable format
alias mount='mount |column -t'
#
##8: Command short cuts to save time
#
## handy short cuts #
alias h='history'
alias j='jobs -l'
#
##9: Create a new set of commands
#
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'
#
##10: Set vim as default
#
alias edit=nvim
alias vi=nvim
alias svi='sudo nvim'
alias vis='vim "+set si"'
alias fv='vim `fzf`'
alias fn='nvim `fzf`'
alias fa='nano `fzf`'
#
##11: Control output of networking tool called ping
#
## Stop after sending count ECHO_REQUEST packets #
alias ping='ping -c 5'
#
## Do not wait interval 1 second, go fast #
alias fastping='ping -c 100 -s.2'
#
#
##11: Control etworking tool called ping
#
alias ports='netstat -tulanp'
alias Port80="netstat -tlpn | awk -F '[: ]+' '\$1==\"tcp\"{print \$5}' | grep -w 80"
alias Port443="netstat -tlpn | awk -F '[: ]+' '\$1==\"tcp\"{print \$5}' | grep -w 443"
Port() {
  netstat -tlpn | awk -F '[: ]+' '$1=="tcp"{print $5}' | grep -w $1
}

real_addr(){
  your_domain=$1
  ping ${your_domain} -c 1 | sed '1{s/[^(]*(//;s/).*//;q}'
}

cert() {
	#申请https证书
  your_domain=$1
  if [[ ! -d "~/.acme.sh/" ]]; then
    curl https://get.acme.sh | sh
  fi
	mkdir ~/certs/$your_domain
	~/.acme.sh/acme.sh  --issue  -d $your_domain  --standalone
  ~/.acme.sh/acme.sh  --installcert  -d  $your_domain   \
        --key-file   ~/certs/$your_domain/private.key \
        --fullchain-file ~/certs/$your_domain/fullchain.cer
}
#
#
##14: Control firewall (iptables) output
#
### shortcut  for iptables and pass it via sudo#
alias ipt='sudo /sbin/iptables'
# 
## display all rules #
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'


##15: Debug web server / cdn problems with curl
#
## get web server headers #
alias header='curl -I'
# 
## find out if remote server supports gzip / mod_deflate or not #
alias headerc='curl -I --compress'
#
##16: Add safety nets
#
alias rm='rm -I --preserve-root'
# 
## confirmation #
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
# 
## Parenting changing perms on / #
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
#
## do not delete / or prompt if deleting more than 3 files at a time # 
#
##17: Update Debian Linux server
#
## distro specific  - Debian / Ubuntu and friends #
## install with apt-get
alias apt-get="sudo apt-get"
alias updatey="sudo apt-get --yes"
# 
## update on one command
alias update='sudo apt-get update && sudo apt-get upgrade'
#
##19: Tune sudo and su
#
## become root #
alias root='sudo -i'
alias su='sudo -i'
#
##20: Pass halt/reboot via sudo
#
## reboot / halt / poweroff
alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'

# 22. run npc in pi and nps in debian
pi-npc(){
	cd ~/npc
	nohup ./npc &
}

debian-nps(){
	cd ~/nps
	nohup ./nps &
}

# 22.  docker shortcuts
alias figup="sudo docker-compose up -d"
alias figdown="sudo docker-compose down"
alias drit="sudo docker run -it"
alias deit="sudo docker exe -it"
alias dpl="sudo docker pull"
alias dps="sudo docker ps -a"
alias dis="sudo docker images"
alias dra="sudo docker ps -a | awk 'NR!=1{ print \$1 }' | xargs sudo docker rm"
alias dsa="sudo docker ps -a | awk 'NR!=1{ print \$1 }' | xargs sudo docker stop"
alias dria="sudo docker images | awk 'NR!=1{ print \$3 }' | xargs sudo docker rmi"

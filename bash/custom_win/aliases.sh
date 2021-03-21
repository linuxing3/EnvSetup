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
#
alias c='clear'
# 
# alias ll='ls -la'
# 
alias l.='ls -d .*'

if [ "$(command -v exa)" ]; then
    unalias 'll'
    unalias 'l'
    unalias 'la'
    unalias 'ls'
    alias ls='exa -G  --color auto  -a -s type'
    alias ll='exa -l --color always -a -s type'
fi

if [ "$(command -v bat)" ]; then
  alias cat='bat'
fi

if [ "$(command -v fd)" ]; then
  alias find='fd'
fi

if [ "$(command -v ranger)" ]; then
  alias explorer='ranger'
fi

if [ "$(command -v goful)" ]; then
  alias finder='goful'
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
alias edit=nvim-qt
alias vi=nvim-qt
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
## confirmation #
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
# 
## Parenting changing perms on / #
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

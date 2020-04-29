# if user is not root, pass all commands via sudo #
if [ $UID -ne 0 ]; then
  alias reboot='sudo reboot'
  alias update='sudo apt-get upgrade'
fi
#
alias c='clear'
# 
alias ll='ls -la'
# 
alias l.='ls -d .*'

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
alias vi=vim
alias svi='sudo vi'
alias vis='vim "+set si"'
alias edit='vim'
#
##11: Control output of networking tool called ping
#
## Stop after sending count ECHO_REQUEST packets #
alias ping='ping -c 5'
#
## Do not wait interval 1 second, go fast #
alias fastping='ping -c 100 -s.2'
#
alias ports='netstat -tulanp'
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


## 21. git alias
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcoo='git fetch && git checkout'

alias gbr='git branch'
alias gbrd='git branch -d'
alias gbrD='git branch -D'

alias gmerge='git branch --merged'

alias gst='git status'
alias gaa='git add -A .'

alias gcm='git commit -m'
alias gaacm='git add -A . && git commit -m'
alias gcp='git cherry-pick'
alias gamend='git commit --amend -m'
alias gdev='git  !git checkout dev && git pull origin dev'
alias gstagi='git checkout staging && git pull origin staging'
alias gmastegit='git checkout master && git pull origin '

alias gpo='git push origin'
alias gpod='git push origin dev'
alias gpos='git push origin staging'
alias gpom='git push origin master'
alias gpoh='git push origin HEAD'

alias gpogm='git push origin gh-pages && git checkout master && git pull origin master && git rebase gh-pages && git push origin master && git checkout gh-pages'
alias gpomg='git git push origin master && git checkout gh-pages && git pull origin gh-pages && git rebase master && git push origin gh-pages && git checkout master'

alias gplo='git  pull origin'
alias gplod='git  pull origin dev'
alias gplos='git  pull origin staging'
alias gplom='git  pull origin master'
alias gploh='git  pull origin HEAD'

alias gls='git log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate'
alias gll='git log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'

alias gf="git ls-files | grep -i"
alias ggr='git grep -Ii'

alias gla='git config -l | grep alias | cut -c 7-'

# 22. run npc in pi and nps in debian
pi-npc(){
	cd ~/npc
	nohup ./npc &
}

debian-nps(){
	cd ~/nps
	nohup ./nps &
}

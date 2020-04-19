# You can put files here to add functionality separated per file, which
# will be ignored by git.
# Files on the custom/ directory will be automatically loaded by the init
# script, in alphabetical order.

# For example: add yourself some shortcuts to projects you often work on.
#

alias reload="source ~/.bashrc"
alias db="cd ~/Dropbox"
alias ws="cd ~/workspace"
alias bashconfig="emacsclient -c ~/.bashrc"
alias ohmybash="emacsclient -c ~/.oh-my-bash"

alias nis="npm install --save "
alias svim='sudo vim'

alias install='sudo apt get install'
alias update='sudo apt-get update; sudo apt-get upgrade'

alias ..="cd .."
alias ...="cd ..; cd .."

alias www='python -m SimpleHTTPServer 8000'

alias sock5='ssh -D 8080 -q -C -N -f root@xunqinji.top'

alias caddystatus="ssh root@xunqinji.top 'bash -s' < local.script.sh"
alias trojanstatus="ssh root@xunqinji.top ARG1="arg1" ARG2="arg2" 'bash -s' < local_script.sh"


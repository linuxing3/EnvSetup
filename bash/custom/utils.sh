#!/usr/bin/env bash
# linuxing's Bash Utils Script 
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

###############################
## Basic tools
###############################

# Usage: backup fileone 
backup() {
  if [ -e "$1" ]; then
    echo
    msg "\\033[1;34m==>\\033[0m Attempting to back up your original file or directory"
    today=$(date +%Y%m%d_%s)
    mv -v "$1" "$1.$today"

    ret="$?"
    success "Your original configuration has been backed up"
  fi
}

# Usage: ask "    - action?"
ask() {
  while true; do
    read -p "$1 ([y]/n) " -r
    REPLY=${REPLY:-"y"}
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      return 1
    elif [[ $REPLY =~ ^[Nn]$ ]]; then
      return 0
    fi
  done
}

###############################
# Simple calculator
###############################
calc() {
	local result="";
	result="$(printf "scale=10;$*\n" | bc --mathlib | tr -d '\\\n')";
	#                       └─ default (when `--mathlib` is used) is 20
	#
	if [[ "$result" == *.* ]]; then
		# improve the output for decimal numbers
		printf "$result" |
		sed -e 's/^\./0./'        `# add "0" for cases like ".5"` \
		    -e 's/^-\./-0./'      `# add "0" for cases like "-.5"`\
		    -e 's/0*$//;s/\.$//';  # remove trailing zeros
	else
		printf "$result";
	fi;
	printf "\n";
}

###############################
# Create a data URL from a file
###############################
dataurl() {
	local mimeType=$(file -b --mime-type "$1");
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8";
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
}

###############################
# Create a git.io short URL
###############################
gitio() {
	if [ -z "${1}" -o -z "${2}" ]; then
		echo "Usage: \`gitio slug url\`";
		return 1;
	fi;
	curl -i http://git.io/ -F "url=${2}" -F "code=${1}";
}

###############################
# Start an HTTP server from a directory, optionally specifying the port
###############################
server() {
	# local port="${1:-8000}";
	# sleep 1 && open "http://localhost:${port}/" &
	# Set the default Content-Type to `text/plain` instead of `application/octet-stream`
	# And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
	# python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port";
	http-server -o . && lt -s xingwenju -p 8080
}

###############################
# Quick convert from decimal to binary
###############################
dec2bin(){
	python -c $'bin($1)';
}

###############################
# Start a PHP server from a directory, optionally specifying the port
# (Requires PHP 5.4.0+.)
###############################
phpserver() {
	local port="${1:-4000}";
	local ip=$(ifconfig getifaddr en1);
	sleep 1 && open "http://${ip}:${port}/" &
	php -S "${ip}:${port}";
}


###############################
# Compare original and gzipped file size
###############################
gz() {
	local origsize=$(wc -c < "$1");
	local gzipsize=$(gzip -c "$1" | wc -c);
	local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l);
	printf "orig: %d bytes\n" "$origsize";
	printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio";
}

###############################
# UTF-8-encode a string of Unicode symbols
###############################
escape() {
	printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u);
	# print a newline unless we’re piping the output to another program
	if [ -t 1 ]; then
		echo ""; # newline
	fi;
}

###############################
# Decode \x{ABCD}-style Unicode escape sequences
###############################
unidecode() {
	perl -e "binmode(STDOUT, ':utf8'); print \"$@\"";
	# print a newline unless we’re piping the output to another program
	if [ -t 1 ]; then
		echo ""; # newline
	fi;
}

###############################
# Get a character’s Unicode code point
###############################
codepoint() {
	perl -e "use utf8; print sprintf('U+%04X', ord(\"$@\"))";
	# print a newline unless we’re piping the output to another program
	if [ -t 1 ]; then
		echo ""; # newline
	fi;
}

###############################
# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
###############################
getcertnames() {
	if [ -z "${1}" ]; then
		echo "ERROR: No domain specified.";
		return 1;
	fi;

	local domain="${1}";
	echo "Testing ${domain}…";
	echo ""; # newline

	local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
		| openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1);

	if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
		local certText=$(echo "${tmp}" \
			| openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
			no_serial, no_sigdump, no_signame, no_validity, no_version");
		echo "Common Name:";
		echo ""; # newline
		echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//";
		echo ""; # newline
		echo "Subject Alternative Name(s):";
		echo ""; # newline
		echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
			| sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2;
		return 0;
	else
		echo "ERROR: Certificate not found.";
		return 1;
	fi;
}

###############################
# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
###############################
tre() {
	tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}

###############################
# Compile and execute a C source on the fly
###############################
EC() { echo -e '\e[1;33m'code $?'\e[m\n'; }

csource() {
        [[ $1 ]]    || { echo "Missing operand" >&2; return 1; }
        [[ -r $1 ]] || { printf "File %s does not exist or is not readable\n" "$1" >&2; return 1; }
	local output_path=${TMPDIR:-/tmp}/${1##*/};
	gcc "$1" -o "$output_path" && "$output_path";
	rm "$output_path";
	return 0;
}

extract() {
    local c e i

    (($#)) || return

    for i; do
        c=''
        e=1

        if [[ ! -r $i ]]; then
            echo "$0: file is unreadable: \`$i'" >&2
            continue
        fi

        case $i in
            #*.t@(gz|lz|xz|b@(2|z?(2))|a@(z|r?(.@(Z|bz?(2)|gz|lzma|xz)))))
                   #c=(bsdtar xvf);;
            *.7z)  c=(7z x);;
            *.Z)   c=(uncompress);;
            *.bz2) c=(bunzip2);;
            *.exe) c=(cabextract);;
            *.gz)  c=(gunzip);;
            *.rar) c=(unrar x);;
            *.xz)  c=(unxz);;
            *.zip) c=(unzip);;
            *)     echo "$0: unrecognized file extension: \`$i'" >&2
                   continue;;
        esac

        command "${c[@]}" "$i"
        ((e = e || $?))
    done
    return "$e"
}

###############################
# cd and ls in one
###############################
cl() {
    dir=$1
    if [[ -z "$dir" ]]; then
        dir=$HOME
    fi
    if [[ -d "$dir" ]]; then
        cd "$dir"
        ls
    else
        echo "bash: cl: '$dir': Directory not found"
    fi
}

###############################
# GTD and other productivity tools
###############################
note () {
    # if file doesn't exist, create it
    if [[ ! -f $HOME/.notes ]]; then
        touch "$HOME/Dropbox/org/.notes"
    fi

    if ! (($#)); then
        # no arguments, print file
        cat "$HOME/Dropbox/org/.notes"
    elif [[ "$2" == "-c" ]]; then
        # clear file
        > "$HOME/Dropbox/org/.notes"
    else
        # add all arguments to file
        printf "%s\n" "$*" >> "$HOME/Dropbox/org/.notes"
    fi
}

todo() {
    if [[ ! -f $HOME/.todo ]]; then
        touch "$HOME/Dropbox/org/.todo"
    fi

    if ! (($#)); then
        cat "$HOME/Dropbox/org/.todo"
    elif [[ "$1" == "-l" ]]; then
        nl -b a "$HOME/Dropbox/org/.todo"
    elif [[ "$1" == "-c" ]]; then
        > "$HOME/Dropbox/org/.todo"
    elif [[ "$1" == "-r" ]]; then
        nl -b a "$HOME/Dropbox/org/.todo"
        printf "----------------------------\n"
        read -p "Type a number to remove: " number
        ex -sc "${number}d" "$HOME/Dropbox/org/.todo"
    else
        printf "%s\n" "$*" >> "$HOME/Dropbox/org/.todo"
    fi
}

docview() {
    if [[ -f $1 ]] ; then
        case $1 in
            *.pdf)       evince   "$1" ;;
            *.ps)        evince "$1" ;;
            *.odt)       oowriter "$1" ;;
            *.txt)       vim  "$1" ;;
            *.md)        w3m  "$1" ;;
            *.markdown)  w3m  "$1" ;;
            *.doc)       oowriter "$1" ;;
            *)           printf "don't know how to extract '%s'..." "$1" >&2; return 1 ;;
        esac
    else
        printf "'%s' is not a valid file!\n" "$1" >&2
        return 1;
    fi
}


###############################
# network tools proxies
###############################
# proxies
###############################
#export http_proxy=http://127.0.0.1:3127
#export ftp_proxy=http://127.0.0.1:3127
#export https_proxy=http://127.0.0.1:3127
###############################
assignProxy() {
   PROXY_ENV="http_proxy ftp_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY ALL_PROXY"
   for envar in $PROXY_ENV
   do
     export $envar=$1
   done
}

clrProxy() {
   assignProxy "" # This is what 'unset' does.
}

mfaProxy() {
   export no_proxy="10.0.*,localhost,127.0.0.1,localaddress,.localdomain.com"
   #user=YourUserName
   #read -p "Password: " -s pass &&  echo -e " "
   #proxy_value="http://$user:$pass@ProxyServerAddress:Port"
   proxy_value="http://192.168.5.55:80"
   assignProxy $proxy_value
}


###############################
# Git tools
###############################
deploy() {

  today=$(date +'%Y-%m-%d-%H:%M')

  git add .
  git commit -m "Commited by $USER from $PWD on $today"
  git push
}

###############################
# Docker tools
###############################

dk() {
    MENU="start pull push run img ps rml rma" 
    select opt in $MENU; do 
		if [ "$opt" = "start" ]; then 
			systemctl start docker
			break
		elif [ "$opt" = "pull" ]; then 
			docker pull $1
			break
		elif [ "$opt" = "push" ]; then 
			docker push $1
			break
		elif [ "$opt" = "run" ]; then 
			docker run -it -v /playground:/playground $1 /bin/bash
			break
		elif [ "$opt" = "img" ]; then 
			docker images 
			break
		elif [ "$opt" = "ps" ]; then 
			docker ps -lq
		elif [ "$opt" = "rml" ]; then 
			docker rm `docker ps -lq` 
			break
		elif [ "$opt" = "rma" ]; then 
			docker rm `docker ps -aq` 
			break
		else 
			echo bad option 
			break
		fi 
	done
}



params() {
  while [ "$1" != "" ]; do
      case $1 in
          -s  )   shift
                  SERVER=$1 ;;
          -d  )   shift
                  DATE=$1 ;;
          --paramter|p ) shift
                  PARAMETER=$1;;
          -h|help  )   usage #  call
                  exit ;;
          * )     usage # All other parameters
                  exit 1
      esac
      shift
  done
}


selectmenu() {
  PS3='Please enter your choice: '
  options=("Option 1" "Option 2" "Option 3" "Quit")
  select opt in "${options[@]}"
  do
      case $opt in
          "Option 1")
              echo "you chose choice 1"
              ;;
          "Option 2")
              echo "you chose choice 2"
              ;;
          "Option 3")
              echo "you chose choice $REPLY which is $opt"
              ;;
          "Quit")
              break
              ;;
          *) echo "invalid option $REPLY";;
      esac
  done
}


abspath() {
  FILE="$0"
  while [[ -h ${FILE} ]]; do
      FILE="`readlink "${FILE}"`"
  done
  pushd "`dirname "${FILE}"`" > /dev/null
  DIR=`pwd -P`
  popd > /dev/null
}


gnudate() {
    if hash gdate 2> /dev/null; then
        gdate "$@"
    else
        date "$@"
    fi
}

search() {
  sed -n "1,\$p" $1 | grep -m10 -nF $2
}


###############################
## devops tools
###############################

alias xqj="ssh -X -l root xunqinji.top -L 22:127.0.0.1:2222"
alias dx="ssh -X -l root dongxishijie.xyz -L 22:127.0.0.1:2221"
alias vag="ssh -X -l root -p 2222 localhost -L 2222:127.0.0.1:22"

alias stop_watching1="ssh -l root xunqinji.top '/bin/systemctl stop trojan && /bin/systemctl stop v2ray'"
alias start_watching1="ssh -l root xunqinji.top '/bin/systemctl restart trojan && /bin/systemctl restart v2ray'"

alias stop_watching2="ssh -l root dongxishijie.xyz '/bin/systemctl stop trojan && /bin/systemctl stop v2ray'"
alias start_watching2="ssh -l root dongxishijie.xyz '/bin/systemctl restart trojan && /bin/systemctl restart v2ray'"

alias caddystatus="ssh root@xunqinji.top 'bash -s' < local.script.sh"
alias trojanstatus="ssh root@xunqinji.top ARG1="arg1" ARG2="arg2" 'bash -s' < local_script.sh"

sync_envs_repo() {

  green "|-------------------***--------------------------***---------------------------------|"
  green "Updating xunqinji.top root EnvSetup repo"
  ssh -l root xunqinji.top 'cd /root/EnvSetup && git pull'
  green "|-------------------***--------------------------***---------------------------------|"

  green "Updating xunqinji.top vagrant EnvSetup repo"
  ssh -l vagrant xunqinji.top 'cd /home/vagrant/EnvSetup && git pull'
  green "|-------------------***--------------------------***---------------------------------|"

  green "Updating dongxishijie.xyz root EnvSetup repo"
  ssh -l root dongxishijie.xyz 'cd /root/EnvSetup && git pull'
  green "|-------------------***--------------------------***---------------------------------|"

  green "Updating dongxishijie.xyz vagrant EnvSetup repo"
  ssh -l vagrant dongxishijie.xyz 'cd /home/vagrant/EnvSetup && git pull'
  green "|-------------------***--------------------------***---------------------------------|"

  green "Updating Office Openwrt EnvSetup repo"
  ssh -p 8026 root@xunqinji.top 'cd /root/EnvSetup && git pull'
  green "|-------------------***--------------------------***---------------------------------|"

  green "Updating Office Vagrant Nodejs EnvSetup repo"
  ssh -l vagrant -p 8027 xunqinji.top 'cd /home/vagrant/EnvSetup && git pull'
  green "|-------------------***--------------------------***---------------------------------|"
}

show_ports() {
  local ports=$(netstat -ntlp | grep "${1:nps}" | awk '{ print $4}' | sed 's/://g')
  for p in $ports
  do
    echo "===================================="
    netcat -z -v -w 1 -n 127.0.0.1 $p
  done
}

deploy_hugo_gh() {
  local INPUT_DESTINATION_REPO="linuxing3/linuxing3.github.io"
  local GITHUB_ACTOR=linuxing3
  local TS=$(date +"%Y%m%d% %H:%M")
  hugo -D
  cd public
  git init
  git remote add origin "https://github.com/${INPUT_DESTINATION_REPO}.git"
  git config user.name "${GITHUB_ACTOR}"
  git config user.email "${GITHUB_ACTOR}@qq.com"
  git add --all
  git commit -m "Automated deployment by ${USER} at ${TS}"
  # git push origin --delete master
  git push -u origin master
  cd
}

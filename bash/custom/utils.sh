###############################
## Basic tools
###############################
blue(){
    echo -e "\033[34m\033[01m$1\033[0m"
}

green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}

red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}

msg() {
  printf '%b\n' "$1" >&2
}

success() {
  if [ "$ret" -eq '0' ]; then
    msg "\\33[32m[✔]\\33[0m ${1}${2}"
  fi
}

error() {
  msg "\\33[31m[✘]\\33[0m ${1}${2}"
  exit 1
}

# Usage: exists git
exists() {
  command -v "$1" >/dev/null 2>&1
}
# Usage: backup fileone 
backup() {
  if [ -e "$1" ]; then
    echo
    msg "\\033[1;34m==>\\033[0m Attempting to back up your original vim configuration"
    today=$(date +%Y%m%d_%s)
    mv -v "$1" "$1.$today"

    ret="$?"
    success "Your original configuration has been backed up"
  fi
}

check_git() {
  if ! exists "git"; then
    error "You must have 'git' installed to continue"
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

# Usage: remove_line filename \
#           "line contents"
remove_line() {
  # find the src file from use input
  src=$(readlink "$1")
  if [ $? -eq 0 ]; then
    echo "Remove from $1 ($src):"
  else
    src=$1
    echo "Remove from $1:"
  fi

  shift
  line_no=1
  match=0
  while [ -n "$1" ]; do
    # 1. locate the line
    line=$(sed -n "$line_no,\$p" "$src" | \grep -m1 -nF "$1")
    if [ $? -ne 0 ]; then
      shift
      line_no=1
      continue
    fi
    # 2. get line number
    line_no=$(( $(sed 's/:.*//' <<< "$line") + line_no - 1 ))
    # 3. get line contents
    content=$(sed 's/^[0-9]*://' <<< "$line")
    match=1
    echo    "  - Line #$line_no: $content"
    # 4. double check?
    [ "$content" = "$1" ] || ask "    - Remove?"
    if [ $? -eq 0 ]; then
      awk -v n=$line_no 'NR == n {next} {print}' "$src" > "$src.bak" &&
        mv "$src.bak" "$src" || break
      echo  "      - Removed"
    else
      echo  "      - Skipped"
      line_no=$(( line_no + 1 ))
    fi
  done
  [ $match -eq 0 ] && echo "  - Nothing found"
  echo
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

note () {
    # if file doesn't exist, create it
    if [[ ! -f $HOME/.notes ]]; then
        touch "$HOME/Dropbox/org/.notes"
    fi

    if ! (($#)); then
        # no arguments, print file
        cat "$HOME/Dropbox/org/.notes"
    elif [[ "$1" == "-c" ]]; then
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

###############################
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
# handle proxies
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
#push and pull
###############################
deploy() {

  today=$(date +%Y%m%d_%s)

  git add .
  git commit -m "$today"
  git push
}

dk() {
    MENU="start pull push run img ps rml rma" 
    select opt in $MENU; do 
		if [ "$opt" = "start" ]; then 
			startdocker
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


###############################
## FS tools
###############################

#  dir and cd into it   
mcd() {  
    mkdir -pv "$@"  
    cd "$@"  
} 

# Create a new directory and enter it
mkd() {
	mkdir -p "$@" && cd "$@";
}

touchexe() {
	touch "$@" && chmod +x "$@";
}

# Change working directory to the top-most Finder window location
cdf() { # short for `cdfinder`
	cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')";
}

ck() {  
  while true; do  
    clear;  
    echo "";  
    echo "    $(date +%r)";  
    echo "";  
    sleep 1;  
  done  
}  

fix() {  
  if [ -d $1 ]; then  
    find $1 -type d -exec chmod 755 {} \;  
    find $1 -type f -exec chmod 644 {} \;  
  else  
    echo "$1 is not a directory."  
  fi  
}  

###############################
## zip tools
###############################
# Create a .tar
mktar(){ tar cvf  "${1%%/}.tar"     "${1%%/}/"; }  

# Create a .tar.gz
mktgz(){ tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }  

# Create a .tar.bz2
mktbz(){ tar cvjf "${1%%/}.tar.bz2" "${1%%/}/"; }

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
mktgz2() {
	local tmpFile="${@%/}.tar";
	tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1;

	size=$(
		stat -f"%z" "${tmpFile}" 2> /dev/null; # OS X `stat`
		stat -c"%s" "${tmpFile}" 2> /dev/null # GNU `stat`
	);

	local cmd="";
	if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
		# the .tar file is smaller than 50 MB and Zopfli is available; use it
		cmd="zopfli";
	else
		if hash pigz 2> /dev/null; then
			cmd="pigz";
		else
			cmd="gzip";
		fi;
	fi;

	echo "Compressing .tar using \`${cmd}\`…";
	"${cmd}" -v "${tmpFile}" || return 1;
	[ -f "${tmpFile}" ] && rm "${tmpFile}";
	echo "${tmpFile}.gz created successfully.";
}

# Determine size of a file or total size of a directory
fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh;
	else
		local arg=-sh;
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@";
	else
		du $arg .[^.]* *;
	fi;
}


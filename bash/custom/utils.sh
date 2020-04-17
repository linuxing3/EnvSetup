# Simple calculator

function calc() {
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

# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$@";
}

function touchexe() {
	touch "$@" && chmod +x "$@";
}

# Change working directory to the top-most Finder window location
function cdf() { # short for `cdfinder`
	cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')";
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
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
function fs() {
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

# Use Git’s colored diff when available
hash git &>/dev/null;
if [ $? -eq 0 ]; then
	function diff() {
		git diff --no-index --color-words "$@";
	}
fi;

# Create a data URL from a file
function dataurl() {
	local mimeType=$(file -b --mime-type "$1");
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8";
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
}

# Create a git.io short URL
function gitio() {
	if [ -z "${1}" -o -z "${2}" ]; then
		echo "Usage: \`gitio slug url\`";
		return 1;
	fi;
	curl -i http://git.io/ -F "url=${2}" -F "code=${1}";
}

# Start an HTTP server from a directory, optionally specifying the port
function server() {
	# local port="${1:-8000}";
	# sleep 1 && open "http://localhost:${port}/" &
	# Set the default Content-Type to `text/plain` instead of `application/octet-stream`
	# And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
	# python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port";
	http-server -o . && lt -s xingwenju -p 8080
}

# Quick convert from decimal to binary
function dec2bin(){
	python -c $'bin($1)';
}

# Start a PHP server from a directory, optionally specifying the port
# (Requires PHP 5.4.0+.)
function phpserver() {
	local port="${1:-4000}";
	local ip=$(ifconfig getifaddr en1);
	sleep 1 && open "http://${ip}:${port}/" &
	php -S "${ip}:${port}";
}


# Compare original and gzipped file size
# Compare original and gzipped file size
function gz() {
	local origsize=$(wc -c < "$1");
	local gzipsize=$(gzip -c "$1" | wc -c);
	local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l);
	printf "orig: %d bytes\n" "$origsize";
	printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio";
}

# Syntax-highlight JSON strings or files
# Usage: `json '{"foo":42}'` or `echo '{"foo":42}' | json`
function json() {
	if [ -t 0 ]; then # argument
		python -mjson.tool <<< "$*" | pygmentize -l javascript;
	else # pipe
		python -mjson.tool | pygmentize -l javascript;
	fi;
}

# Run `dig` and display the most useful info
#function digga() {
	#dig +nocmd "$1" any +multiline +noall +answer;
#}

# UTF-8-encode a string of Unicode symbols
function escape() {
	printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u);
	# print a newline unless we’re piping the output to another program
	if [ -t 1 ]; then
		echo ""; # newline
	fi;
}

# Decode \x{ABCD}-style Unicode escape sequences
function unidecode() {
	perl -e "binmode(STDOUT, ':utf8'); print \"$@\"";
	# print a newline unless we’re piping the output to another program
	if [ -t 1 ]; then
		echo ""; # newline
	fi;
}

# Get a character’s Unicode code point
function codepoint() {
	perl -e "use utf8; print sprintf('U+%04X', ord(\"$@\"))";
	# print a newline unless we’re piping the output to another program
	if [ -t 1 ]; then
		echo ""; # newline
	fi;
}

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
function getcertnames() {
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

# `s` with no arguments opens the current directory in vscode, otherwise
# opens the given location
function vsc() {
	if [ $# -eq 0 ]; then
		code .;
	else
		code "$@";
	fi;
}

# `a` with no arguments opens the current directory in Atom Editor, otherwise
# opens the given location
function a() {
	if [ $# -eq 0 ]; then
		atom .;
	else
		atom "$@";
	fi;
}

# `v` with no arguments opens the current directory in Vim, otherwise opens the
# given location
function v() {
	if [ $# -eq 0 ]; then
		nvim .;
	else
		nvim "$@";
	fi;
}

# `o` with no arguments opens the current directory, otherwise opens the given
# location
function o() {
	if [ $# -eq 0 ]; then
		open .;
	else
		open "$@";
	fi;
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
	tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}

# Compile and execute a C source on the fly
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

# cd and ls in one
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
        touch "$HOME/dotfiles/data/.notes"
    fi

    if ! (($#)); then
        # no arguments, print file
        cat "$HOME/dotfiles/data/.notes"
    elif [[ "$1" == "-c" ]]; then
        # clear file
        > "$HOME/dotfiles/data/.notes"
    else
        # add all arguments to file
        printf "%s\n" "$*" >> "$HOME/dotfiles/data/.notes"
    fi
}

todo() {
    if [[ ! -f $HOME/.todo ]]; then
        touch "$HOME/dotfiles/data/.todo"
    fi

    if ! (($#)); then
        cat "$HOME/dotfiles/data/.todo"
    elif [[ "$1" == "-l" ]]; then
        nl -b a "$HOME/dotfiles/data/.todo"
    elif [[ "$1" == "-c" ]]; then
        > "$HOME/dotfiles/data/.todo"
    elif [[ "$1" == "-r" ]]; then
        nl -b a "$HOME/dotfiles/data/.todo"
        printf "----------------------------\n"
        read -p "Type a number to remove: " number
        ex -sc "${number}d" "$HOME/dotfiles/data/.todo"
    else
        printf "%s\n" "$*" >> "$HOME/dotfiles/data/.todo"
    fi
}

docview () {
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

# trap EC ERR

# autocd
#shopt -s autocd

# zsh help

# handle proxies
#export http_proxy=http://127.0.0.1:3127
#export ftp_proxy=http://127.0.0.1:3127
#export https_proxy=http://127.0.0.1:3127
assignProxy(){
   PROXY_ENV="http_proxy ftp_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY ALL_PROXY"
   for envar in $PROXY_ENV
   do
     export $envar=$1
   done
 }

clrProxy(){
   assignProxy "" # This is what 'unset' does.
 }

mfaProxy(){
   export no_proxy="10.0.*,localhost,127.0.0.1,localaddress,.localdomain.com"
   #user=YourUserName
   #read -p "Password: " -s pass &&  echo -e " "
   #proxy_value="http://$user:$pass@ProxyServerAddress:Port"
   proxy_value="http://192.168.5.55:80"
   assignProxy $proxy_value  
 }

cntlmProxy(){
   export no_proxy="10.0.*,localhost,127.0.0.1,localaddress,.localdomain.com"
   proxy_value="http://10.0.2.1:3127"
   assignProxy $proxy_value  
 }
wallProxy(){
   export no_proxy="10.0.*,localhost,127.0.0.1,localaddress,.localdomain.com"
   proxy_value="http://127.0.0.1:8087"
   assignProxy $proxy_value  
 }

#push and pull from git.oschina.net
gitPush(){
	git add .
	git commit -m "autopush"  
	git push
}

gitPull(){
	git pull origin master
}

gitHelp(){
	echo This is the help of Quick Git Commands
	echo --------------------------------------
	echo 1. cloneosa wiki101
	echo 2. clonegh mongoblog
	echo 3. addremote url
	echo 4. orphan branch_name
	echo 5. clean
	echo 6. gitproxy 127.0.0.1:3127
	echo 7. gitautologin
	echo --------------------------------------
	echo End of help
}


# Start a nginx server from a directory, optionally specifying the port
# (Requires openresty)
runresty(){
    MENU="default currentDir"
    select opt in $MENU;do
        if [ "$opt" = "default" ]; then
            echo Stopping resty server
            /usr/local/openresty/nginx/sbin/nginx -s stop
            echo Starting resty server on default directory
            /usr/local/openresty/nginx/sbin/nginx
            break
        elif [ "$opt" = "currentDir" ]; then
            echo Stopping resty server
            /usr/local/openresty/nginx/sbin/nginx -s stop
            echo Starting resty server on current directory
            /usr/local/openresty/nginx/sbin/nginx -p . -c nginx.conf
            break
        fi
    done
}

dockerMenu(){
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

startGAE(){
	echo Starting GAE Proxy Server on 127.0.0.1:8087
	systemctl stop goagent
	systemctl start goagent
	ps aux|grep [g]oagent
	echo Done
}  

startJdc(){
	echo Setting environment of jdc for you
	export ACCESS_KEY='258c3aef428148408f38a5ff87e96b6a'
	export SECRET_KEY='c083a32ffde645a9a49662b3013e58d9wbmmT1iX'
}

startdocker(){
	echo Starting Docker
	#if [ /var/run/docker.sock ]; then
		#echo Docker Daemon started already! Skipping!
	#else
		docker -d &
	#fi
}

mktar(){ tar cvf  "${1%%/}.tar"     "${1%%/}/"; }  
mktgz(){ tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }  
mktbz(){ tar cvjf "${1%%/}.tar.bz2" "${1%%/}/"; }

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

#  dir and cd into it   
mcd(){  
    mkdir -pv "$@"  
    cd "$@"  
} 

put(){
    source ~/env.sh
    qboxrsctl put -c $1 $2 $2;
}
# init commands
# mfaProxy
# startdocker


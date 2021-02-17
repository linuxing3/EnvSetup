# set go environment
#
ggg() {
	if [ -e /usr/lib/go/bin/go ]; then
		export GOROOT=/usr/lib/go
	elif [ -e /usr/local/go ]; then
		export GOROOT=/usr/local/go
	fi
	if [ ! -d "$HOME/gopath/src/github.com" ]; then
		mkdir -p "$HOME/gopath/src/github.com"
	fi
	export GO111MODULE=on
	export GOPATH=$HOME/go
	export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
}

ggg

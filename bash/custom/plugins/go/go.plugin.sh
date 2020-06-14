# set go environment
#
ggg() {
	if [ -e /usr/lib/go/bin/go ]; then
		export GOROOT=/usr/lib/go
	elif [ -e /usr/local/bin/go/bin/go ]; then
		export GOROOT=/usr/local/bin/go
	fi
	if [ ! -d "$HOME/gopath/github.com" ]; then
		mkdir -p "$HOME/gopath/github.com"
	fi
	export GO111MODULE=on
	export GOPATH=$HOME/gopath
	export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
}

ggg

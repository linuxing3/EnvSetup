# set go environment
#
ggg() {
	if [ -e /usr/lib/go/bin/go ]; then
		export GOROOT=/usr/lib/go
	elif [ -e /usr/local/bin/go/bin/go ]; then
		export GOROOT=/usr/local/bin/go
	fi
	export GO111MODULE=on
	if [ ! -d "$HOME/workspace/go-project" ]; then
		mkdir -p "$HOME/workspace/go-project"
	fi
	export GOPATH=$HOME/workspace/go-project
	export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
}

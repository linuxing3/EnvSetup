#!/usr/bin/env sh

echo "Usage"

echo "bash -C https://raw.githubusercontent.com/linuxing3/EnvSetup/master/bootstrap.sh"

blue() {
	echo -e "\033[34m\033[01m$1\033[0m"
}
green() {
	echo -e "\033[32m\033[01m$1\033[0m"
}
red() {
	echo -e "\033[31m\033[01m$1\033[0m"
}

function bootstrap() {
	green "======================="
	blue "Installing vps for you"
	green "======================="
	cd
	sudo apt update -y
	sudo apt install -y git curl wget tmux
	git clone https://github.com/linuxing3/EnvSetup
	bash EnvSetup/bash/bin/install-core-packages.sh
	bash EnvSetup/bash/bin/install-bash.sh
	bash EnvSetup/bash/bin/install-tmux.sh
	bash EnvSetup/bash/bin/install-vim.sh
	bash EnvSetup/bash/bin/configure-locale.sh
	cd
}

bootstrap

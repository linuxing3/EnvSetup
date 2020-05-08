#!/usr/bin/env bash
#install hugo
# check arch, if i686, download 32 bit

version=64
arch=$(arch)
if [ $arch == "i686" ]; then
	version="32"
fi

install_hugo() {
	wget -O hugo.deb "https://github.com/gohugoio/hugo/releases/download/v0.70.0/hugo_0.70.0_Linux-${version}bit.deb "
	sudo dpkg -i hugo.deb
	type hugo
}

sample_blog() {
	cd ~
	mkdir blogs
	cd blogs
	read -p -r "Input dirname of your blog(like myblog):    " rootdir
	# create site
	hugo new site --force ${rootdir}

	# install them
	cd ${rootdir}
	git init
	git submodule add https://github.com/budparr/gohugo-theme-ananke.git themes/ananke
	echo 'theme = "ananke"' >>config.toml
	sed -i 's/example\.org/xunqinji\.top\/hugo/g' config.toml
	echo "Done with theme settings!"

	# build
	echo "Build your site for deployment!"
	hugo -D
}

option=$(dialog --title " Hugo 一键安装自动脚本" \
	--checklist "请输入:" 20 70 5 \
	"1" "Install hugo" 0 \
	"2" "Create sample blog" 0 \
	3>&1 1>&2 2>&3 3>&1)
case "$option" in
1)
	install_hugo
	;;
2)
	sample_blog
	;;
*)
	echo "Skipped!"
	;;
esac

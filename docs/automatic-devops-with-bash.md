# 自动化运维脚本之 bash 篇

bash 脚本短小精悍，表现力强，适用普遍，可以在本机和远程服务器上进行快速的运维操作，
堪称运维工程师的不二选择。

通过编写 bash 脚本，可以很快地整合工作流，从日常重复性劳动中解脱出来，当然这也需要
一定的编程基础。

在我的脚本中，主要针对常用的 vim、emacs、bash、nginx、tmux、nps、trojan、v2ray 等，
采取了自动下载和自动安装的功能，

其中一部分是直接借用了其他人的一键脚本，比如 on-my-bash、oh-my-tmux、SpaceVim、
Doom Emacs 等等。

# 入口文件

`install.sh`

主要作用是检查当前的版本，提醒运用是否开始进行初始化配置

# 初始化脚本`bootstrap`和`bootstrap-ui`，两者区别在于后者可以使用`dialog`作为可视化界面。

```bash
#!/usr/bin/env bash
start_menu(){
  clear
  option=$(dialog --title " Vps 一键安装自动脚本 2020-2-27 更新 " \
    --checklist "请输入:" 20 70 5 \
    "vim" "Dark side editor" 0 \
    "bash" "Your shell" 0 \
    "emacs" "Another zen editor" 0 \
    "tmux" "Multi screen" 0 \
    "python" "Fast programming language" 0 \
    "nvm" "nvm+npm" 0 \
    "caddy" "Caddy Web Server" 0 \
    "trojan" "Trojan proxy Server" 0 \
    "v2ray" "V2ray proxy Server" 0 \
    "nps" "Nps server and client" 0 \
    "fonts" "Popular nerd fonts" 0 \
    "app" "Configure some command tools" 0 \
    "network" "Configure network" 0 \
    "locale" "Configure locale" 0 \
    3>&1 1>&2 2>&3 3>&1)
  green "Your choosed the ${option}"
  case "$option" in
    vim)
    install_vim
    ;;
    bash)
    install_bash
    ;;
    emacs)
    install_emacs
    ;;
    tmux)
    install_tmux
    ;;
    python)
    install_python
    ;;
    nvm)
    install_nvm
    ;;
    caddy)
    install_caddy
    ;;
    trojan)
    install_trojan
    ;;
    v2ray)
    install_v2ray
    ;;
    nps)
    install_nps
    ;;
    fonts)
    config_fonts
    ;;
    app)
    config_app
    ;;
    network)
    config_network
    ;;
    locale)
    config_locale
    ;;
    *)
    clear
    exit 1
    ;;
  esac
}
```

# 模块安装文件

## vim

使用`SpaceVim`的安装脚本

## emacs

使用`doom emacs`的安装脚本，可选择是否使用我自己的`doom-emacs-private`配置

## tmux

## bash

使用`oh-my-bash`，主要考虑是全平台使用，包括`windows`

同时，将个人设置统一防止在`EnvSetup/bash/custom`下，包括常用的别名、函数、帮助器、颜色配置。

将 git、vim、emacs、pyenv、nvm 等设置也集成在模块插件的目录下，方便按需调用。

比如如果你在`.bashrc`中启用了 python 插件，插件将自动将`./local/pyenv`加入到路径中去

如果你按下`vv`，将实际执行`pyenv`的初始化脚本，加载`pyenv virtualenvs -`

下一步可以执行`pyenv install`、`pyenv global 3.8.2`、`pyenv virtualenv-create v1`、`pyenv activate v1`等一系列脚本。

我最常用的命令比如推动代码仓库到远程，设置成 bash 函数`deploy`，每次减少一定的代码量。

路径的设置可以更加智能，特别是个人的常用路径，包括将子目录列入路径。大概配置如下：

```sh
#!/usr/bin/env bash

get_subbin() {
    joined_path=$(du "$1" | cut -f2 | tr '\n' ':' | sed 's/:*$//')
    echo $joined_path
}

file_paths=(
"$HOME/EnvSetup/bash/bin"
"$HOME/Dropbox/bin"
"$HOME/bin"
"$HOME/.local/bin"
"$HOME/.nvm/bin"
"$HOME/.pyenv/bin"
)

for dir in "${file_paths[@]}"; do
  if [[ -d $dir ]] && [[ ! "$PATH" == "*$dir*" ]]; then
    subdirs=$(get_subbin $dir)
    # echo "Adding the following $subdirs to path"
    export PATH="$PATH:$subdirs"
  fi
done
```

## trojan

直接借用`scaleya`的一键脚本，自动完成证书申请，程序安装和服务配置。

```sh

#!/bin/bash

read -p "请输入Domain:" domain
read -p "请输入Password:" password
echo "\$domain
\$password
"|bash <(curl -sL https://scaleya.netlify.com/share/trojan.sh)

```

## caddy/nginx

新版的 caddy 已经可以作为软件包下载，配置方式略微不同。

```sh

#!/usr/bin/env bash

backup() {
  echo "-----------------------------"
  echo "Backing up caddy configurations"
  sudo mv caddy /usr/bin/
  sudo mv /etc/caddy/Caddyfile /etc/caddy/Caddyfile.old
  sudo mv /etc/systemd/system/caddy.service /etc/caddy/caddy.service.old
}


install_caddy2() {
  sudo echo "deb [trusted=yes] https://apt.fury.io/caddy/ /" \
      | sudo tee -a /etc/apt/sources.list.d/caddy-fury.list
  sudo apt update
  sudo apt install caddy
  caddy version
  which caddy
  touch /etc/caddy/Caddyfile

  sudo echo "
:80 {
	templates
	encode zstd gzip
  file_server browse
  root * /var/www/html
  reverse_proxy /ray localhost:36722
}
" >> /etc/caddy/Caddyfile

  echo "Enjoy!"
}


run() {
  echo "Caddy启动"
  sudo systemctl daemon-reload
  sudo systemctl stop caddy
  sudo systemctl start caddy
}

```

## v2ray

## nps/npc

很好的内网穿透软件，一开始在下载使用时碰到一些问题，后来记录了一个脚本，进行自动安装。

```sh
#!/usr/bin/env bash
# 判断系统版本
a=""
a=$(arch)
if [[ "${a}" ==  "x86_64" ]]; then
  version="amd64"
elif [[ "${a}" == "i686" ]]; then
  version="386"
elif [[ "${a}" == "armv7l" ]]; then
  version="arm_v7"
fi
echo "Your system architecture is ${a}, downloading ${version} version"

if ! command -v "dialog" >/dev/null 2>&1; then
  sudo apt install -y dialog
else
  echo "Dialog installed!"
fi

install_nps() {
	echo " install nps tunnel server "

	cd
	rm -rf nps
	mkdir nps
	cd nps
	wget "https://github.com/ehang-io/nps/releases/download/v0.26.6/linux_${version}_server.tar.gz"

	tar -xvf "linux_${version}_server.tar.gz"
  # 修改必要的端口和密码
	sed -i 's/http_proxy_port=.*$/http_proxy_port=8081/g' conf/nps.conf
	sed -i 's/https_proxy_port=.*$/https_proxy_port=8443/g' conf/nps.conf

	#web
	sed -i 's/web_host=.*$/web_host=localhost/g ' conf/nps.conf
	sed -i 's/web_username=.*$/web_username=admin/g' conf/nps.conf
	sed -i 's/web_password=.*$/web_password=mm123456/g ' conf/nps.conf
	sed -i 's/web_port = 8090/web_port=8090/g' conf/nps.conf

	echo "----------------------------------------------------------"
	echo "Server Setting Examples"
  sudo mkdir -p /etc/nps/conf
	sudo cp conf/*.* /etc/nps/conf/

	sudo ./nps install

	echo "----------------------------------------------------------"
	echo "Trying to start nps"
	sudo nps stop
	sudo nps start

	ps ax | grep nps
	if [[ ! -z $? ]];then
	  echo "nps server is ready!"
	fi
}


install_npc() {
	echo "----------------------------------------------------------"
	echo "Trying to install npc"

	cd
	rm -rf npc
	mkdir npc
	cd npc

	wget "https://github.com/ehang-io/nps/releases/download/v0.26.6/linux_${version}_client.tar.gz"
	tar xvf "linux_${version}_client.tar.gz"

	touch run-npc
	chmod +x run-npc
	cat >> run-npc << EOF
cd ~/npc
nohup ./npc &
EOF
	mv conf/npc.conf conf/npc.default.conf
	cat > conf/npc.conf << EOF
[common]
server_addr=35.235.80.5:8024
conn_type=tcp
vkey=13901229638
auto_reconnection=true
max_conn=1000
flow_limit=1000
rate_limit=1000
basic_username=978
basic_password=916
web_username=user
web_password=mm123456
crypt=true
compress=true

[tcp]
mode=tcp
server_port=11116
target_addr=127.0.0.1:22
EOF

  user=$(whoami)
  dir=""
  if [[ "${user}" == "root" ]]; then
    dir="/root"
  else
    dir="/home/${user}"
  fi
	echo "Uninstall npc is"
  sudo systemctl stop Npc
  sudo ./npc uninstall

  sudo ./npc install -config "${dir}/npc/conf/npc.conf"
  sudo systemctl enable Npc
	echo "Testing npc is running"
  sudo systemctl stop Npc
  sudo systemctl start Npc
  sudo systemctl status Npc
  echo "Checkout ~/npc/conf/npc.default.conf for more examples"
}

```

## 字体下载

建议使用`NerdFont`，包括许多不错的图标，字形也很好看。个人推荐 SourceCodePro,FiraCode, Hack, JetBrainsMono, RobotoMono, SourceCodePro IBMPlexMono。

其中中文显示最秀气的应该是 IBMPlexMono 字体，中文用户可作为首选。

下载链接: https://github.com/ryanoasis/nerd-fonts/releases/download/

```sh
#!/bin/bash

# install unzip just in case the user doesn't already have it.
sudo apt-get install unzip -y

fonts="FiraCode Hack JetBrainsMono RobotoMono SourceCodePro IBMPlexMono"
version="2.1.0"

fontface=$(dialog --title " Nerd Fonts 一键安装自动脚本" \
  --checklist "请输入:" 20 70 5 \
  "FiraCode" "Fira Code Nerd fonts" 0 \
  "Hack" "Hack Nerd Fonts" 0 \
  "JetBrainsMono" "JetBrains Mono" 0 \
  "RobotoMono" "Roboto Mono" 0 \
  "SourceCodePro" "Source Code Pro" 0 \
  "IBMPlexMono" "IBM Plex Mono" 0 \
  3>&1 1>&2 2>&3 3>&1)

location="/usr/share/fonts/truetype/${fontface}"
url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/${fontface}.zip"

echo "Installling ${fontface}"
cd
if [[ ! -d fonts ]]; then
  mkdir fonts
fi
cd fonts

rm -rf ${fontface}
mkdir ${fontface}
cd ${fontface}

echo "Fetching ${fontface} fonts from nerd-fonts releases page"
wget $url
unzip ${fontface}.zip
rm ${fontface}.zip

sudo rm -rf $location
sudo mkdir -p $location

if [[ -d $location ]]; then
  sudo cp *.ttf "${location}/"
  sudo cp */*.ttf "${location}/"
  sudo fc-cache -fv
  dialog --title "Success" --msgbox "Installed ${fontface} ${version}" 5 70
else
  dialog --title "Failed" --msgbox "Not Installed ${fontface} ${version}" 5 70
fi

echo "For all fonts, clone the repository and install"
echo "git clone https://github.com/ryanoasis/nerd-fonts"
```

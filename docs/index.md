# 自动化运维

![Sync envSetup in my vps](https://github.com/linuxing3/EnvSetup/workflows/Sync%20envSetup%20in%20my%20vps/badge.svg)

## Devops

[devops document](/EnvSetup/automatic-devops-with-bash)

bash 脚本短小精悍，表现力强，适用普遍，可以在本机和远程服务器上进行快速的运维操作，
堪称运维工程师的不二选择。

通过编写 bash 脚本，可以很快地整合工作流，从日常重复性劳动中解脱出来，当然这也需要
一定的编程基础。

在我的脚本中，主要针对常用的 vim、emacs、bash、nginx、tmux、nps、trojan、v2ray 等，
采取了自动下载和自动安装的功能，

其中一部分是直接借用了其他人的一键脚本，比如 on-my-bash、oh-my-tmux、SpaceVim、
Doom Emacs 等等。

## Proxies

[proxy document](/EnvSetup/vps-management-style)

经过不断调整，基本尝试了 VPS 服务器上部署服务的诸多技巧，颇有心得，谨以为记。

第一步：在腾讯云上购买域名

第二步：在 cloudflare 上注册加强 dns 服务

第三步：在谷歌云上申请免费 VPS，可以用不同用户注册，使用同一信用卡，达到多次免费

第四步：在 VPS 服务器上部署服务

## Windows management and setup

[windows document](/EnvSetup/windows-management-style)

This is the script for linuxing3 to setup a new dev box. You can modify the
scripts to fit your own requirements.

## Prerequisites

- A clean install of Windows 10 Pro

## How to Use

```bash
curl https://raw.githubusercontent.com/linuxing3/EnvSetup/master/install.sh >> env-setup.sh | chmod +x env-setup.sh | ./env-setup --install
```

## Openwrt

[Openwrt ](/EnvSetup/openwrt-management-style)

## Vim, tmux, bash

[Vim ](/EnvSetup/vim-cheatsheet)

[Tmux](/EnvSetup/tmux-cheatsheet)

## Languages

[Bash](/EnvSetup/bash-cheatsheet)

[Go](/EnvSetup/go-cheatsheet)

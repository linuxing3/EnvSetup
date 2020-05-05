# 网络运维的思路和架构V2ray

经过不断调整，基本尝试了VPS服务器上部署服务的诸多技巧，颇有心得，谨以为记。

第一步：在腾讯云上购买域名

第二步：在cloudflare上注册加强dns服务

第三步：在谷歌云上申请免费VPS，可以用不同用户注册，使用同一信用卡，达到多次免费

第四步：在VPS服务器上部署服务


# 服务器部署具体方案

## `Trojan`代理服务器配置

对外暴露443端口，接收各类请求

对普通流量，转发到80端口

对`trojan`加密流量，进行解析和响应

采用`ssl`加密技术，使用`acme`生成的证书

## `V2ray`代理服务器配置

监听36772端口，启用`websocket-tls`

## Web服务器群

### `caddy`配置

服务80端口，作为伪站点

Tips:

将`ray/`子目录，反向代理到`v2ray`的36772

### `Ngnix`配置

主要站点配置文件

`/www/server/nginx/conf/nginx.conf`

其中通过`include`引入虚拟主机的配置文件,还有其他的一些文件

`/www/server/nginx/conf/enable_php.conf`
`/www/server/nginx/conf/proxy.conf`
`/www/server/nginx/conf/fastcgi.conf`

### 虚拟主机配置

使用宝塔创建一系列虚拟站点

均使用`ssl`，指向生成证书

虚拟站点配置文件

`/www/server/panel/vhosts/nginx/*.conf`

Tips:
使用反向代理到v2ray的36772

站点列表

- 19001 反向代理php服务器

- 19002 固定目录站点

- 19003 固定目录站点

- 19004 php站点

- 19008 phpmyadmin站点


### `mysql`数据库服务器

监听3306端口

### `fastcgi/php`服务器配置

分别监听9000端口，和pid文件

## `NPS`服务器和客户端

客户端直接连接本地服务器，并建立以下隧道

内网穿透和隧道

- 9001指向19001

- 9002指向19002

- 9003指向19003

- 9004指向19004

Tips

其它端口，可以指向办公室电脑、虚拟机、家里的笔记本、树莓派等等，达到内网穿透的目的

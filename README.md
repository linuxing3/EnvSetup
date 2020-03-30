# Windows 10 Developer Machine Setup

This is the script for Edi Wang to setup a new dev box. You can modify the scripts to fit your own requirements.

## Prerequisites

- A clean install of Windows 10 Pro v1903 en-us.
- If you are in China: a stable "Internet" connection.

> This script has not been tested on other version of Windows, please be careful if you are using it on other Windows versions.

## How to Use

Download latest script here: https://github.com/linuxing3/EnvSetup

### Optional

Import "Add_PS1_Run_as_administrator.reg" to your registry to enable context menu on the powershell files to run as Administrator.

### Run Install.ps1 as Administrator

- Set a New Computer Name
- Disable Sleep on AC Power
- Add 'This PC' Desktop Icon (need refresh desktop)
- Remove "Microsoft Edge" desktop shortcut icon
- Enable Developer Mode (for UWP Development)
- Enable Remote Desktop
- Install IIS
  - ASP.NET 4.8
  - Dynamic and Static Compression
  - Basic Authentication
  - Windows Authentication
  - Server Side Includes
  - WebSockets
- Install Chocolate for Windows
  - 7-Zip
  - Google Chrome
  - Pot Player
  - Microsoft Teams
  - SysInternals
  - Lightshot
  - FileZilla
  - TeamViewer
  - Notepad++
  - Visual Studio Code
    - C-Sharp
    - Icons
    - MSSQL
    - PowerShell
  - DotPeek
  - LINQPad
  - Fiddler
  - Git
  - GitHub for Windows
  - FFMpeg
  - CURL
  - WGet
  - OpenSSL
  - Beyond Compare
  - Node.Js
- Remove a few pre-installed UWP applications
  - Messaging
  - CandyCrush
  - Bing News
  - Solitaire
  - People
  - Feedback Hub
  - Your Phone
  - My Office
  - FitbitCoach
  - Netflix

## Proxy

### Setting Nginx as frontend

解释一下这些虚拟主机的一些细节：第一个 server 接收来自 Trojan 的流量，与上面 Trojan 配置文件对应；第二个 server 也是接收来自 Trojan 的流量，但是这个流量尝试使用 IP 而不是域名访问服务器，所以将其认为是异常流量，并重定向到域名；第三个 server 接收除 127.0.0.1:80 外的所有 80 端口的流量并重定向到 443 端口，这样便开启了全站 https，可有效的防止恶意探测。注意到，第一个和第二个 server 对应综述部分原理图中的蓝色数据流，第三个 server 对应综述部分原理图中的红色数据流，综述部分原理图中的绿色数据流不会流到 Nginx。

```
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	root /var/www/html;

	index index.html index.htm index.nginx-debian.html;

	server_name _;

	location / {
		try_files $uri $uri/ =404;
	}

}


# Virtual Host configuration for example.com
#
# You can move that to a different file under sites-available/ and symlink that
# to sites-enabled/ to enable it.
#
server {
	listen 80;
	listen [::]:80;

	server_name dongxishijie.xyz;

	root /var/www/example.com;
	index index.html;

	location / {
		try_files $uri $uri/ =404;
	}
}
```

### Setting with caddy

```sh
dongxishijie.xyz:80 {
    root /var/www/html
    gzip
    browse
    proxy /xcuYGtq localhost:51988 {
        websocket
        header_upstream -Origin
    }
}
```

### Setting trojan as backend server

```
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": 443,
    "remote_addr": "127.0.0.1",
    "remote_port": 80,
    "password": [
        "mm123456",
        "password2"
    ],
    "log_level": 1,
    "ssl": {
        "cert": "/etc/letsencrypt/your-domain/cert.pem",
        "key": "/etc/letsencrypt/your-domain/private.key",
        "key_password": "",
        "cipher": "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY13                               05:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SH                               A256:ECDHE-RSA-AES128-SHA256",
        "prefer_server_cipher": true,
        "alpn": [
            "http/1.1"
        ],
        "reuse_session": true,
        "session_ticket": false,
        "session_timeout": 600,
        "plain_http_response": "",
        "curves": "",
        "dhparam": ""
    },
    "tcp": {
        "prefer_ipv4": false,
        "no_delay": true,
        "keep_alive": true,
        "fast_open": false,
        "fast_open_qlen": 20
    },
    "mysql": {
        "enabled": false,
        "server_addr": "127.0.0.1",
        "server_port": 3306,
        "database": "trojan",
        "username": "trojan",
        "password": ""
    }
}
```

### Setting trojan client

```json
{
  "run_type": "client",
  "local_addr": "127.0.0.1",
  "local_port": 10888,
  "remote_addr": "your_ip",
  "remote_port": 443,
  "password": ["mm123456"],
  "log_level": 1,
  "ssl": {
    "verify": true,
    "verify_hostname": true,
    "cert": "cert.pem",
    "cipher": "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA:AES128-SHA:AES256-SHA:DES-CBC3-SHA",
    "cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
    "sni": "",
    "alpn": ["h2", "http/1.1"],
    "reuse_session": true,
    "session_ticket": false,
    "curves": ""
  },
  "tcp": {
    "no_delay": true,
    "keep_alive": true,
    "reuse_port": false,
    "fast_open": false,
    "fast_open_qlen": 20
  }
}
```

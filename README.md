# Windows 10 Developer Machine Setup

This is the script for linuxing3 to setup a new dev box. You can modify the scripts to fit your own requirements.

## Prerequisites

- A clean install of Windows 10 Pro

## How to Use

Download latest script here: https://github.com/linuxing3/EnvSetup

### Optional

Import `Add_PS1_Run_as_administrator.reg` to your registry to enable context menu on the powershell files to run as Administrator.

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

```json
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

```json
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

```json
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

### V2ray Setting as backend server

If you use the websocket as backend server , you can define a path in the `wsSettings`

```json
{
  "log": {
    "access": "/var/log/v2ray/access.log",
    "error": "/var/log/v2ray/error.log",
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": 51988,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "8c3bf008-f114-4e02-b48a-6ba13a7def77",
            "level": 1,
            "alterId": 233
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "/xcuYGtq" }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls"]
      }
    },
    {
      "protocol": "shadowsocks",
      "port": 44274,
      "settings": {
        "method": "chacha20-ietf-poly1305",
        "password": "mm123456",
        "network": "tcp,udp",
        "level": 1,
        "ota": false
      }
    }
    //include_socks
    //include_mtproto
    //include_in_config
    //
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIP"
      },
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    },
    {
      "protocol": "mtproto",
      "settings": {},
      "tag": "tg-out"
    }
    //include_out_config
    //
  ],
  "dns": {
    "servers": [
      "https+local://cloudflare-dns.com/dns-query",
      "1.1.1.1",
      "1.0.0.1",
      "8.8.8.8",
      "8.8.4.4",
      "localhost"
    ]
  },
  "routing": {
    "domainStrategy": "IPOnDemand",
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "127.0.0.0/8",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "type": "field",
        "inboundTag": ["tg-in"],
        "outboundTag": "tg-out"
      },
      {
        "type": "field",
        "domain": [
          "domain:epochtimes.com",
          "domain:epochtimes.com.tw",
          "domain:epochtimes.fr",
          "domain:epochtimes.de",
          "domain:epochtimes.jp",
          "domain:epochtimes.ru",
          "domain:epochtimes.co.il",
          "domain:epochtimes.co.kr",
          "domain:epochtimes-romania.com",
          "domain:erabaru.net",
          "domain:lagranepoca.com",
          "domain:theepochtimes.com",
          "domain:ntdtv.com",
          "domain:ntd.tv",
          "domain:ntdtv-dc.com",
          "domain:ntdtv.com.tw",
          "domain:minghui.org",
          "domain:renminbao.com",
          "domain:dafahao.com",
          "domain:dongtaiwang.com",
          "domain:falundafa.org",
          "domain:wujieliulan.com",
          "domain:ninecommentaries.com",
          "domain:shenyun.com"
        ],
        "outboundTag": "blocked"
      },
      {
        "type": "field",
        "protocol": ["bittorrent"],
        "outboundTag": "blocked"
      }
      //include_ban_ad
      //include_rules
      //
    ]
  },
  "transport": {
    "kcpSettings": {
      "uplinkCapacity": 100,
      "downlinkCapacity": 100,
      "congestion": true
    }
  }
}
```

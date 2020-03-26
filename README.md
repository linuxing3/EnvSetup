# Windows 10 Developer Machine Setup

This is the script for Edi Wang to setup a new dev box. You can modify the scripts to fit your own requirements.

## Prerequisites

- A clean install of Windows 10 Pro v1903 en-us.
- If you are in China: a stable "Internet" connection.

> This script has not been tested on other version of Windows, please be careful if you are using it on other Windows versions.

## How to Use

Download latest script here: https://go.edi.wang/aka/envsetup

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

### Nginx

解释一下这些虚拟主机的一些细节：第一个server接收来自Trojan的流量，与上面Trojan配置文件对应；第二个server也是接收来自Trojan的流量，但是这个流量尝试使用IP而不是域名访问服务器，所以将其认为是异常流量，并重定向到域名；第三个server接收除127.0.0.1:80外的所有80端口的流量并重定向到443端口，这样便开启了全站https，可有效的防止恶意探测。注意到，第一个和第二个server对应综述部分原理图中的蓝色数据流，第三个server对应综述部分原理图中的红色数据流，综述部分原理图中的绿色数据流不会流到Nginx。

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

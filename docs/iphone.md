title: Iphone手机通过电脑上网
date: 2015-12-3 09:30:43
tags:
---

## 基本思路

使用`itools`的端口转发功能，将手机的22端口

如果要实现手机通过电脑上网，则必须是反向转发，即将手机端口转发到电脑的端口

`putty`就有端口转发的功能，但必须要用`usb`通过`ssh`连接到手机的`ssh`服务器才行

因此，要建立多个端口转发

1. 电脑`22`到手机`22` （用`itools`）

2. 手机`1985`到本机的socks代理`192.168.76.54`的`1985` （用`putty`）

3. 手机`1986`到公司的http代理`192.168.5.31`的`80` （用`putty`）

4. 本机的socks代理`192.168.76.54`的`1985`连接远程vps，实现上网

## 手机端：

1. 安装shadowsocks和ssh

越狱后，使用`Cydia`安装。

shadowsocks的基本配置如下

```
	{
	    "server":"vps-ip",
	    "server_port":1984,
	    "local_address": "0.0.0.0",
	    "local_port":1983,
	    "password":"20090909",
	    "timeout":300,
	    "method":"aes-256-cfb",
	    "fast_open": false
	}
```

2. 设置shadowsocks的pac文件

启动自动代理

使用pac文件

```
var mfa = "PROXY 127.0.0.1:1986;PROXY 127.0.0.1:1986;";
var hexie = "SOCKS5 127.0.0.1:1985; SOCKS 127.0.0.1:1985";
function FindProxyForURL(url, host) {
    if (defaultMatcher.matchesAny(url, host) instanceof BlockingFilter) {
        return hexie;
    }
    return mfa;
}
```

3. 启动程序，这样上国内网就会发送请求到手机的1986端口，翻墙将到1985端口（然后转达到电脑上）

4. 备用方案：设置`APN`的代理(在ios9.0上不能使用)

`设置`-`无线控制`-`移动网络设置`-`接入点名称`--`新APN`

```
    名称：wow
    APN:  3gnet
    代理：127.0.0.1
    端口：1986
```

启用这个`APN`，手机将连接联通的`3G`网络，但数据都从手机自身的`3128`端口走

## 电脑端：

### 将iphone手机用USB线连接到电脑

###　建立bash.vbs文件，启动一个mingw的终端环境

```
	Set fso = CreateObject("Scripting.FileSystemObject")
	Set shell = CreateObject("WScript.Shell")
	Const TemporaryFolder = 2
	linkfile = fso.BuildPath(fso.GetSpecialFolder(TemporaryFolder), "Git Bash.lnk")
	gitdir = fso.GetParentFolderName(WScript.ScriptFullName)
	Set link = shell.CreateShortcut(linkfile)
	link.TargetPath = fso.BuildPath(gitdir, "C:\Program Files\Git\bin\bash.exe")
	link.Arguments = "--login -i"
	link.IconLocation = fso.BuildPath(gitdir, "C:\Program Files\Git\etc\git.ico")
	If WScript.Arguments.Length > 0 Then link.WorkingDirectory = WScript.Arguments(0)
	link.Save
	Set app = CreateObject("Shell.Application")
	app.ShellExecute linkfile
```

### 建立一个vps脚本文件


vps可自行文件

```
echo connecting to vps
echo config file is vps.config
/bin/ssh -F vps.config root@vps-ip
```

vps.config配置文件

```
Host vps-ip 
Port 443
User root
IdentityFile id_rsa
DynamicForward 1080
DynamicForward 1985
LocalForward 443 127.0.0.1:443 
LocalForward 8080 127.0.0.1:8080
LocalForward 1984 127.0.0.1:1984
LocalForward 80 127.0.0.1:80 
ProxyCommand proxytunnel -v -p proxy.mfa.gov.cn:80 -d %h:%p -H "User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Win32)\n"
ServerAliveInterval 540
```

启动后可以连接vps服务器，并且在本机上建立了一个1985的socks端口接受输入数据

### 确认公司的代理服务器`http://192.168.5.31:80`运行正常

### 打开`itools`将电脑`22`转发到手机`22`

### ssh到iphone

####　使用ssh可以登录到iphone的终端并转达

建立一个iphone_console.cmd脚本

```
App\putty\putty.exe -v -X -A -ssh -2 -P 22 -l root -R 1985:127.0.0.1:1985 -R 1986:192.168.5.31:80 127.0.0.1
```

或使用ssh
```
/bin/ssh -v -F iphone.config root@127.0.0.1
```

使用iphone.config文件
```
Host 127.0.0.1 
Port 22
User root
IdentityFile id_rsa
RemoteForward 1985 127.0.0.1:1985 
RemoteForward 1986 192.168.5.31:80
ServerAliveInterval 540
```

#### 使用plink直接转发，可以实时观察转发日志

建立一个iphone_console.cmd脚本

```
App\putty\plink.exe -v -X -A -ssh -2 -P 22 root@127.0.0.1 -p tswc0916 -R 1985:127.0.0.1:1985 -R 1986:192.168.5.31:80 -a -N
```

## 结果测试

速度飞快！
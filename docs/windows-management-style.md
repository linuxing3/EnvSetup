---
title: Windows运维
date: 2020-05-04T09:30:43-30:50
tags:
---

# Windows 10 Developer Machine Setup

This is the script for linuxing3 to setup a new dev box. You can modify the
scripts to fit your own requirements.

## Prerequisites

- A clean install of Windows 10 Pro

## How to Use

Download latest script here: https://github.com/linuxing3/EnvSetup

```bash
curl https://raw.githubusercontent.com/linuxing3/EnvSetup/master/install.sh >> env-setup.sh | chmod +x env-setup.sh | ./env-setup --install
```

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

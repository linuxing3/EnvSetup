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

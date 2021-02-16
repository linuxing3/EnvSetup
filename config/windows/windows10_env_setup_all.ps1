# !/usr/bin/env powershell
#
# Author: linuxing3<linuxing3@qq.com>
# Copyrigtht: MIT
# Date: 2020-05-11
#

# Unblock-File -Path .\windows7_env_setup_packages.ps1
Write-Host "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine"
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

function Check-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# -----------------------------------------------------------------------------
$computerName = Read-Host '输入新的计算机名称'
Write-Host "将本机重命名为: " $computerName  -ForegroundColor Yellow
Rename-Computer -NewName $computerName
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "取消休眠功能" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Powercfg /Change monitor-timeout-ac 20
Powercfg /Change standby-timeout-ac 0
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "添加关于本机到桌面" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
$thisPCIconRegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
$thisPCRegValname = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" 
$item = Get-ItemProperty -Path $thisPCIconRegPath -Name $thisPCRegValname -ErrorAction SilentlyContinue 
if ($item) { 
    Set-ItemProperty  -Path $thisPCIconRegPath -name $thisPCRegValname -Value 0  
} 
else { 
    New-ItemProperty -Path $thisPCIconRegPath -Name $thisPCRegValname -Value 0 -PropertyType DWORD | Out-Null  
} 
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "移除Ddge的桌面图标" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
$edgeLink = $env:USERPROFILE + "\Desktop\Microsoft Edge.lnk"
Remove-Item $edgeLink
# -----------------------------------------------------------------------------
# To list all appx packages:
# Get-AppxPackage | Format-Table -Property Name,Version,PackageFullName
Write-Host "删除不用的组件" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
$uwpRubbishApps = @(
    "Microsoft.Messaging",
    "king.com.CandyCrushSaga",
    "Microsoft.BingNews",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.People",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.YourPhone",
    "Microsoft.MicrosoftOfficeHub",
    "Fitbit.FitbitCoach",
    "4DF9E0F8.Netflix")

foreach ($uwp in $uwpRubbishApps) {
    Get-AppxPackage -Name $uwp | Remove-AppxPackage
}

Write-Host ""
Write-Host "设置Windows 10 开发者模式." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "启用远程桌面并设置防火墙" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\" -Name "fDenyTSConnections" -Value 0
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\" -Name "UserAuthentication" -Value 1
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

if (Check-Command -cmdname 'choco') {
    Write-Host "Choco 已安装"
}
else {
    Write-Host ""
    Write-Host "安装Chocolate for Windows..." -ForegroundColor Green
    Write-Host "------------------------------------" -ForegroundColor Green
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

Write-Host ""
Write-Host "安装常用软件和应用" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "[WARN] Ma de in China: some software like Google Chrome require the true Internet first" -ForegroundColor Yellow

if (Check-Command -cmdname 'git') {
    Write-Host "Git已安装，为你升级"
    choco update git -y
}
else {
    Write-Host ""
    Write-Host "安装Git for Windows..." -ForegroundColor Green
    choco install git -y
}

if (Check-Command -cmdname 'node') {
    Write-Host "Node.js已安装，为你升级"
    choco update nodejs -y
}
else {
    Write-Host ""
    Write-Host "安装Nodejs" -ForegroundColor Green
    choco install nodejs -y
}

Write-Host ""
Write-Host "安装常用软件, wget, curl, fd, repgrep, powershell, 7zip" -ForegroundColor Green
choco install wget -y
choco install curl -y
choco install fd -y
choco install ripgrep -y
choco install powershell7 -y
choco install 7zip.install -y
choco install vscode -y
choco install vscode-powershell -y

Write-Host ""
Write-Host "建议安装的常用软件, googlechrome等等" -ForegroundColor Green
Write-Host "choco install googlechrome -y"
Write-Host "choco install potplayer -y"
Write-Host "choco install dotnetcore-sdk" -y
Write-Host "choco install ffmpeg -y"
Write-Host "choco install openssl.light" -y
Write-Host "choco install vscode-csharp" -y
Write-Host "choco install vscode-icons" -y
Write-Host "choco install vscode-mssql" -y
Write-Host "choco install sysinternals -y"
Write-Host "choco install notepadplusplus.install" -y
Write-Host "choco install dotpeek -y"
Write-Host "choco install linqpad -y"
Write-Host "choco install fiddler -y"
Write-Host "choco install beyondcompare -y"
Write-Host "choco install filezilla -y"
Write-Host "choco install lightshot.install" -y
Write-Host "choco install microsoft-teams".install -y
Write-Host "choco install teamviewer -y"
Write-Host "choco install github-desktop" -y

Write-Host "------------------------------------" -ForegroundColor Green
Read-Host -Prompt "安装完成，按回车重启系统！"
Restart-Computer
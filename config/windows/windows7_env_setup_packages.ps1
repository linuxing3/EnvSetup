# !/usr/bin/env powershell
#
# Author: linuxing3<linuxing3@qq.com>
# Copyrigtht: MIT
# Date: 2020-05-11

# Unblock-File -Path .\windows7_env_setup_packages.ps1
Write-Host "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine"

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

function Check-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}


if (Check-Command -cmdname 'choco') {
    Write-Host "Choco is already installed, skip installation."
}
else {
    Write-Host ""
    Write-Host "Installing Chocolate for Windows..." -ForegroundColor Green
    Write-Host "------------------------------------" -ForegroundColor Green
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

Write-Host ""
Write-Host "Installing Applications..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "For development environment" -ForegroundColor Yellow

if (Check-Command -cmdname 'git') {
    Write-Host "Git is already installed, checking new version..."
    #choco upgrade git -y
}
else {
    Write-Host ""
    Write-Host "Installing Git for Windows..." -ForegroundColor Green
    choco install git -y
}

if (Check-Command -cmdname 'node') {
    Write-Host "Node.js is already installed, checking new version..."
    #choco upgrade nodejs -y
}
else {
    Write-Host ""
    Write-Host "Installing Node.js..." -ForegroundColor Green
    choco install nodejs -y
}

if (Check-Command -cmdname 'conda') {
    Write-Host "python is already installed, checking new version..."
    #choco upgrade anaconda3 -y
}
else {
    Write-Host ""
    Write-Host "Installing python..." -ForegroundColor Green
    choco install anaconda3 -y
}

Write-Host "Installing fonts" -ForegroundColor Green
choco install hackfont -y
choco install firacode -y
choco install sourcecodepro -y
choco install cascadiacode -y
choco install source-han-sans-cn -y
choco install robotofonts -y

Write-Host "Installing tools" -ForegroundColor Green
choco install 7zip.install -y
choco install googlechrome -y
#choco install potplayer -y
#choco install dotnetcore-sdk -y
#choco install ffmpeg -y
choco install wget -y
#choco install openssl.light -y

Write-Host "Installing ssh tools" -ForegroundColor Green
choco install emacs greprip -y
choco install vim-tux.install -y
choco install spf13-vim -y

Write-Host "Installing vscode" -ForegroundColor Green
choco install vscode.install -y
#choco install vscode-powershell -y
#choco install vscode-python -y
#choco install vscode-java -y
#choco install vscode-icons -y
#choco install vscode-prettier -y
#choco install vscode-vsonline -y
#choco install vscode-chrome-debug -y
#choco install vscode-eslint -y
#choco install vscode-gitlens -y
#choco install vscode-settingssync -y

# choco install sysinternals -y
# choco install dotpeek -y
# choco install linqpad -y
# choco install fiddler -y
# choco install beyondcompare -y

Write-Host "Installing ssh tools" -ForegroundColor Green
choco install putty -y
choco install WinSCP -y
#choco install filezilla -y
# choco install lightshot.install -y

Write-Host "Installing team tools" -ForegroundColor Green
# choco install microsoft-teams.install -y
# choco install teamviewer -y
# choco install github-desktop -y
#choco install vagrant -y
#choco install virtualbox -y
#choco install nodejs -y
#choco install python -y

#pip install --user pipenv

Write-Host "------------------------------------" -ForegroundColor Green
Read-Host -Prompt "Setup is done, restart is needed, press [ENTER] to quit."
#Restart-Computer

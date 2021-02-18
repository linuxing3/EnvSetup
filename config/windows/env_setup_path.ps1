# !/usr/bin/env powershell
#
# Author: linuxing3<linuxing3@qq.com>
# Copyrigtht: MIT
# Date: 2020-05-11
# Usage: Script to set environment variables and putty themes
#


# Unblock-File -Path %
Write-Host "将为您设置系统可执行文件路径。如果出现错误，请先运行以下命令开启验证"
Write-Host "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine"
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }


# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "设置GOPATH和GOROOT " $computerName  -ForegroundColor Yellow
Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "SET [GOPATH] to" $homedir "go"  -ForegroundColor Yellow
Write-Host "SET [GOROOT] to" $drive "go"  -ForegroundColor Yellow
[System.Environment]::SetEnvironmentVariable('GOPATH', $homedir + 'go',[System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('GOROOT', $drive + 'go',[System.EnvironmentVariableTarget]::Machine)

# -----------------------------------------------------------------------------
# 
Write-Host "设置NVM Environment variables " $computerName  -ForegroundColor Yellow
[System.Environment]::SetEnvironmentVariable('NVM_HOME', 'C:\lib\nvm', [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('NVM_SYMBLINK', 'C:\lib\nodejs',[System.EnvironmentVariableTarget]::Machine)

# -----------------------------------------------------------------------------
#
Write-Host ""
Write-Host "设置路径PATH" $computerName  -ForegroundColor Yellow
Write-Host "------------------------------------" -ForegroundColor Green
$env_reg='Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment'
$defaultPath='%USERPROFILE%\AppData\Local\Microsoft\WindowsApps;%USERPROFILE%\.emacs.d\bin;%USERPROFILE%\.doom.d\bin;%USERPROFILE%\go\bin;%USERPROFILE%\.deno\bin;%USERPROFILE%\OneDrive\bin;%NVM_HOME%;%NVM_SYMLINK%;C:\lib\clangd\bin;C:\lib\Neovim\bin;C:\lib\nginx;C:\lib\npc;C:\lib\nvm;C:\lib\PuTTYPortable\App\putty;C:\lib\PuTTYPortable\App\winscp;C:\lib\PuTTYPortable;C:\lib\rsync;C:\Users\Administrator\AppData\Local\nvim\plugged\fzf\bin;C:\lib\mingw\mingw64\bin;C:\lib\heroku\bin;%GOROOT%\bin;%GOPATH%\bin;'
$originalPath = (Get-ItemProperty -Path $env_reg -Name PATH).path
$originalPath = $defaultPath + $originalPath + ';'


Write-Host "------------------------------------" -ForegroundColor Green
Read-Host -Prompt "安装完成！"

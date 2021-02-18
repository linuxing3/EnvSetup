# !/usr/bin/env powershell
#
# Author: linuxing3<linuxing3@qq.com>
# Copyrigtht: MIT
# Date: 2020-05-11
# Usage: Script to set environment variables and putty themes
#

# Unblock-File -Path %
Write-Host "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine"
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$homedir=[System.Environment]::GetEnvironmentVariable('USERPROFILE') + '\'
[System.Environment]::SetEnvironmentVariable('HOME', $homedir,[System.EnvironmentVariableTarget]::Machine)

# -----------------------------------------------------------------------------
# Seting Emacs server file
Write-Host "设置Emacs的参数:EMACS_SERVER_FILE, DATA_DRIVE, CLOUD_SERVICE_PROVIDER " $computerName  -ForegroundColor Yellow
[System.Environment]::SetEnvironmentVariable('EMACS_SERVER_FILE', $HOME + '\.emacs.d\.local\cache\server\server',[System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('DATA_DRIVE', $homedir,[System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('CLOUD_SERVICE_PROVIDER', $homedir,[System.EnvironmentVariableTarget]::Machine)

$send_to_emacs_reg='Registry::HKEY_CLASSES_ROOT\directory\shell\Emacsclient'
$send_to_emacs_value = 'C:\ProgramData\chocolatey\lib\Emacs\tools\emacs\bin\emacsclientw.exe -n -c'
Set-ItemProperty -Path $send_to_emacs_reg -Name Command -Value $send_to_emacs_value

$auto_run_reg = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
$auto_run_value = $homedir + 'EnvSetup\config\windows\emacs-daemon.vbs'
Set-ItemProperty -Path $auto_run_reg -Name 'emacsdaemon' -Value $auto_run_value

# -----------------------------------------------------------------------------
# 
Write-Host "设置NVM Environment variables " $computerName  -ForegroundColor Yellow
[System.Environment]::SetEnvironmentVariable('NVM_HOME', 'C:\lib\nvm', [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('NVM_SYMBLINK', 'C:\lib\nodejs',[System.EnvironmentVariableTarget]::Machine)

Write-Host "------------------------------------" -ForegroundColor Green
Read-Host -Prompt "安装完成！"

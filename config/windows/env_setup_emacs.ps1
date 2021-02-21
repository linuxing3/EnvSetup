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

$homedir=[System.Environment]::GetEnvironmentVariable("USERPROFILE") + "\"
[System.Environment]::SetEnvironmentVariable("HOME", $homedir,[System.EnvironmentVariableTarget]::Machine)

Write-Host "设置doom emacs" $computerName  -ForegroundColor Yellow
git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
git clone https://github.com/linuxing3/doom-emacs-private ~/.doom.d
cmd /C "~/.emacs.d/bin/doom sync"

$server_file=$homedir + ".emacs.d\.local\cache\server\server"
$provider=Read-Host -Prompt "Cloud Service Provider"
# -----------------------------------------------------------------------------
# Seting Emacs server file
Write-Host "设置Emacs的参数:EMACS_SERVER_FILE, DATA_DRIVE, CLOUD_SERVICE_PROVIDER " -ForegroundColor Yellow
[System.Environment]::SetEnvironmentVariable("EMACS_SERVER_FILE", $server_file,[System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable("DATA_DRIVE", $homedir,[System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable("CLOUD_SERVICE_PROVIDER", $provider,[System.EnvironmentVariableTarget]::Machine)

$send_to_emacs_reg="Registry::HKEY_CLASSES_ROOT\directory\shell\Emacsclient"
$send_to_emacs_value = "C:\ProgramData\chocolatey\lib\Emacs\tools\emacs\bin\emacsclientw.exe -n -c"
Set-ItemProperty -Path $send_to_emacs_reg -Name Command -Value $send_to_emacs_value

$auto_run_reg = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$auto_run_value = $homedir + "EnvSetup\config\windows\emacs-daemon.vbs"
Set-ItemProperty -Path $auto_run_reg -Name "emacsdaemon" -Value $auto_run_value

Write-Host "--------------安装完成------------------" -ForegroundColor Green

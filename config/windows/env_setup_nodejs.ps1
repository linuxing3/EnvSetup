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
# 
Write-Host "设置NVM Environment variables " $computerName  -ForegroundColor Yellow
[System.Environment]::SetEnvironmentVariable('NVM_HOME', 'C:\lib\nvm', [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('NVM_SYMBLINK', 'C:\lib\nodejs',[System.EnvironmentVariableTarget]::Machine)

Write-Host "------------------------------------" -ForegroundColor Green

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

$homedir=[System.Environment]::GetEnvironmentVariable('USERPROFILE')
[System.Environment]::SetEnvironmentVariable('HOME', $homedir,[System.EnvironmentVariableTarget]::User)

# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "设置GOPATH和GOROOT " $computerName  -ForegroundColor Yellow
Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "SET [GOPATH] to" $homedir "\go"  -ForegroundColor Yellow
Write-Host "SET [GOROOT] to" $drive "\go"  -ForegroundColor Yellow
[System.Environment]::SetEnvironmentVariable('GOPATH', $homedir + '\go',[System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable('GOROOT', 'B:\lib\go',[System.EnvironmentVariableTarget]::User)

# !/usr/bin/env powershell
#
# Author: linuxing3<linuxing3@qq.com>
# Copyrigtht: MIT
# Date: 2020-05-11
#

# Unblock-File -Path %
Write-Host "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine"
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$homedir=[System.Environment]::GetEnvironmentVariable('USERPROFILE') + '\'
[System.Environment]::SetEnvironmentVariable('HOME', homedir,[System.EnvironmentVariableTarget]::Machine)


$setup_path=$homedir + '\EnvSetup\config\windows'
Write-Host "进入安装目录:" + $setup_path -ForegroundColor Green
cd $setup_path

Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "开始设置" -ForegroundColor Green
.\env_setup_default.ps1
.\env_setup_path.ps1

Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "设置Emacs的参数" -ForegroundColor Green
.\env_setup_emacs.ps1

Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "设置Packages包管理" -ForegroundColor Green
.\env_setup_packges.ps1
.\env_setup_powershell_packges.ps1


Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "设置nodejs" -ForegroundColor Green
.\env_setup_nodejs.ps1

Write-Host "设置putty" -ForegroundColor Green
.\env_setup_putty.ps1

Write-Host "设置rdp" -ForegroundColor Green
.\env_setup_rdp.ps1

Write-Host "------------------------------------" -ForegroundColor Green
Read-Host -Prompt "安装完成，按回车重启系统！"
Restart-Computer
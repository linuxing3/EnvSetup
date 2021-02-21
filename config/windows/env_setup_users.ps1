# !/usr/bin/env powershell
#
# Author: linuxing3<linuxing3@qq.com>
# Copyrigtht: MIT
# Date: 2020-05-11
#
# Unblock-File -Path %
Write-Host "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine"
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

Get-CimInstance -Class Win32_OperatingSystem

Get-CimInstance -Class Win32_OperatingSystem | Get-Member -MemberType Property

Get-CimInstance -ClassName Win32_ComputerSystem -Property UserName | Select-Object -Property UserName

Write-Host "------------------------------------" -ForegroundColor Green
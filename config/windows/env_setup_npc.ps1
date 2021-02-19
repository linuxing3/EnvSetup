# !/usr/bin/env powershell
#
# Author: linuxing3<linuxing3@qq.com>
# Copyrigtht: MIT
# Date: 2020-05-11
#
# Unblock-File -Path %
Write-Host "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine"
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# Create a service
$command = '"c:\lib\npc\npc.exe install -config c:\lib\npc\npc.conf"'
New-Service -Name "Npc" -BinaryPathName $command
Set-Service -Name Npc -StartupType 'Automatic'

# Get service
Get-Service -Name Npc | Select-Object -Property Name

# Set-Service -Name Npc -Status Running
Start-Service Npc

Write-Host "------------------------------------" -ForegroundColor Green
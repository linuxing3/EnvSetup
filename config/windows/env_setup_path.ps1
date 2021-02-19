# !/usr/bin/env powershell
#
# Author: linuxing3<linuxing3@qq.com>
# Copyrigtht: MIT
# Date: 2020-05-11
# Usage: Script to set environment variables and putty themes
#

$system_env_reg='Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment'
$user_env_reg='Registry::HKEY_CURRENT_USER\Environment'

# Unblock-File -Path %
Write-Host "将为您设置系统可执行文件路径。如果出现错误，请先运行以下命令开启验证"
Write-Host "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine"
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$homedir=[System.Environment]::GetEnvironmentVariable('USERPROFILE')
[System.Environment]::SetEnvironmentVariable('HOME', $homedir,[System.EnvironmentVariableTarget]::User)

# -----------------------------------------------------------------------------
#
Write-Host ""
Write-Host "设置路径PATH" $computerName  -ForegroundColor Yellow
Write-Host "------------------------------------" -ForegroundColor Green

$discoveryDrive = 'B:\', 'C:\', 'D:\', 'E:\', 'F:\', 'G:\', $homedir + '\'
$discoveryDir = 'lib', 'app', 'var'
$appPath=''

# 
# 遍历制定目录下的，将【子目录】和【子目录/bin】都加入到路径中
foreach ($drive in $discoveryDrive) {
  foreach ($dir in $discoveryDir) {
    $app_root = $drive + $dir
    if ( Test-Path -Path $app_root -PathType Container ) {
       "目录存在:" + $app_root 
       #  添加这个目录
       $appPath = $app_root + ';' + $appPath
       #  检查子目录
       $app_subDirs = Get-ChildItem($app_root) -Directory
       foreach ($item in $app_subDirs) {
         # 检查子目录作为路径
         $binPath = $app_root + '\' +  $item.Name
         #  检查子目录下的bin子目录
         $subBinPath = $binPath + '\bin'
         if ( Test-Path -Path $subBinPath -PathType Container) {
           $binPath = $binPath + ';' + $subBinPath
         }
         $appPath = $binPath + ';' + $appPath
       }
    }
  }
}

Write-Host '将给当前用户加入以下可执行文件路径:'
$userPathArray = $appPath.Split(';') | Select-Object -Unique
$uniqueUserPath = [System.String]::Join(';', $userPathArray)
Set-ItemProperty -Path $user_env_reg -Name PATH -Value $uniqueUserPath

Write-Host $appPath -ForegroundColor Red

# Optional
# Write-Host '获取现在的系统可执行文件路径:'
# $systemPath = (Get-ItemProperty -Path $system_env_reg -Name PATH).path
# Write-Host '附加上新的可执行文件路径:'
# $systemPath = $appPath + $systemPath

# # 去除重复 
# $systemPathArray = $systemPath.Split(';') | Select-Object -Unique
# $uniqueSystemPath = [System.String]::Join(';', $systemPathArray)

# # 如果路径不是空字符串，就更改系统路径
# if ($uniqueSystemPath -ne "") {
#   Write-Host '更新Path设置:'
#   Set-ItemProperty -Path $system_env_reg -Name PATH -Value $uniqueSystemPath
#   Write-Host $uniqueSystemPath  -ForegroundColor Red
  
#   Write-Host '检查Path设置:'
#   $updatedSystemPath = (Get-ItemProperty -Path $system_env_reg -Name PATH).path
#   Write-Host $updatedSystemPath  -ForegroundColor Green
  
#   Write-Host "------------------------------------" -ForegroundColor Green
#   Read-Host -Prompt "安装完成！"
# } else {
#   Write-Host '路径为空，有错误！' -ForegroundColor Red
# }


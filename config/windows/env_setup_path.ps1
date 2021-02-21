# !/usr/bin/env powershell
#
# Author: linuxing3<linuxing3@qq.com>
# Copyrigtht: MIT
# Date: 2020-05-11
# Usage: Script to set environment variables and putty themes
#

$system_env_reg = 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment'
$user_env_reg = 'Registry::HKEY_CURRENT_USER\Environment'

# Unblock-File -Path %
Write-Host "将为您设置系统可执行文件路径。如果出现错误，请先运行以下命令开启验证"
Write-Host "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine"
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$homedir = [System.Environment]::GetEnvironmentVariable('USERPROFILE')
[System.Environment]::SetEnvironmentVariable('HOME', $homedir, [System.EnvironmentVariableTarget]::User)

# -----------------------------------------------------------------------------
#
Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "设置路径PATH" $computerName  -ForegroundColor Yellow
Write-Host "------------------------------------" -ForegroundColor Green

$homedirWithBackSlash = $homedir + '\'
$discoveryDrive = 'B:\', 'C:\', 'D:\', 'E:\', 'F:\', 'G:\', 'H:\', 'I:\', $homedirWithBackSlash
$discoveryDir = 'lib', 'app', 'var', 'tools', 'bin', 'usr', 'Dropbox', 'Onedrive', 'ICloud', 'GoogleDrive', '.deno', '.cargo', '.emacs.d', '.doom.d', 'go'
$appPath = ''

# 
# 遍历目录下的，将【子目录】和【子目录/bin】都加入到路径中
foreach ($drive in $discoveryDrive) {

  Write-Host "查询"  $drive  "盘..."
  foreach ($dir in $discoveryDir) {
    $app_root = $drive + $dir
    if ( Test-Path -Path $app_root -PathType Container ) {
      Write-Host "--------------------------------------------------" -ForegroundColor Green
      Write-Host "             目录存在" $app_root "                 " -ForegroundColor Green  
      Write-Host "--------------------------------------------------" -ForegroundColor Green
      #  添加这个目录
      $appPath = $app_root + ';' + $appPath
      #  检查子目录
      $app_subDirs = Get-ChildItem($app_root) -Directory
      foreach ($item in $app_subDirs) {
        # 检查子目录作为路径
        $binPath = $app_root + '\' + $item.Name
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

$userPathArray = $appPath.Split(';') | Select-Object -Unique
$uniqueUserPath = [System.String]::Join(';', $userPathArray)
Write-Host $uniqueUserPath -ForegroundColor Red

# 修改当前用户的路径
$shouldUpdateUserPath = Read-Host -Prompt "是否需要修改当前用户路径[Y/N]"
if ($shouldUpdateUserPath -eq 'y') {
  if ($uniqueUserPath -ne "") {
    Write-Host "------------------------------------" -ForegroundColor Green
    Write-Host '将给当前用户加入以下可执行文件路径:'
    Set-ItemProperty -Path $user_env_reg -Name PATH -Value $uniqueUserPath
    Write-Host "------------------------------------" -ForegroundColor Green
    Read-Host -Prompt "安装完成！"
  }
  else {
    Write-Host '路径为空，有错误！' -ForegroundColor Red
  }
}

# 修改系统路径
$shouldUpdateSystemPath = Read-Host -Prompt "是否需要修改系统路径[Y/N]"
if ($shouldUpdateSystemPath -eq 'y') {
  
  Write-Host '获取现在的系统可执行文件路径:'
  $systemPath = (Get-ItemProperty -Path $system_env_reg -Name PATH).path
  Write-Host '附加上新的可执行文件路径:'
  $systemPath = $uniqueUserPath + $systemPath
  
  # # 如果路径不是空字符串，就更改系统路径
  if ($systemPath -ne "") {
    Write-Host "------------------------------------" -ForegroundColor Green
    Write-Host '更新Path设置:'
    Write-Host "------------------------------------" -ForegroundColor Green
    Set-ItemProperty -Path $system_env_reg -Name PATH -Value $systemPath
    Write-Host $systemPath  -ForegroundColor Red
    
    Write-Host '检查Path设置:'
    Write-Host $Env:Path -ForegroundColor Green
    Read-Host -Prompt "安装完成！"
  }
  else {
    Write-Host '路径为空，有错误！' -ForegroundColor Red
  }
  return
}
Write-Host '系统路径无需更新!' -ForegroundColor Red
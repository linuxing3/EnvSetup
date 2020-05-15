# !/usr/bin/env powershell
#
# Author: linuxing3<linuxing3@qq.com>
# Copyrigtht: MIT
# Date: 2020-05-11


# Unblock-File -Path .\windows7_env_setup_path.ps1
Write-Host "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine"
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Changing ENV Variable: [PATH]" $computerName  -ForegroundColor Yellow
Write-Host "------------------------------------" -ForegroundColor Green
$oldPath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
Write-Host "Old Value:" $oldPath  -ForegroundColor Green
Write-Host ""
Write-Host "------------------------------------" -ForegroundColor Green
$newPath = "C:\ProgramData\Anaconda3;C:\ProgramData\Anaconda3\Scripts;C:\ProgramData\Anaconda3\Library\mingw-w64\bin;C:\ProgramData\Anaconda3\Library\usr\bin;C:\ProgramData\Anaconda3\Library\bin;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files\ATI Technologies\ATI.ACE\Core-Static;C:\Program Files\Intel\iCLS Client\;C:\Program Files\Intel\Intel(R) Management Engine Components\DAL;C:\Program Files\Intel\Intel(R) Management Engine Components\IPT;C:\Program Files\NVIDIA Corporation\PhysX\Common;C:\Program Files\YUGUO;C:\ProgramData\chocolatey\bin;C:\Program Files\LLVM\bin;C:\Program Files\Git\cmd;C:\Program Files\Git\mingw32\bin;C:\Program Files\Git\usr\bin;C:\Users\wjb\AppData\Local\Programs\Microsoft VS Code\bin;C:\Users\wjb\AppData\Roaming\nvm;C:\Program Files\nodejs;C:\Program Files\Yarn\bin\;C:\Users\wjb\AppData\Local\Yarn\bin;C:\Program Files\nodejs\node_modules\.bin;C:\Program Files\nodejs\node_modules\windows-build-tools\node_modules\.bin;C:\Users\wjb\AppData\Roaming\nvm\v10.15.3\node_modules\npm\node_modules\npm-lifecycle\node-gyp-bin;D:\lib\bin;D:\lib\ctags58;D:\lib\curl\bin;D:\lib\pt;D:\lib\rsync;D:\lib\subl;D:\lib\UltraISO;D:\Dropbox\bin;D:\lib\Vagrant\bin;C:\Users\wjb\AppData\Local\Pandoc\;C:\tools\neovim\Neovim\bin;C:\tools\Cmder;%GOROOT%\bin;%GOPATH%\bin;"


Write-Host "New Value:" $newPath  -ForegroundColor Green

Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath

Write-Host ""
Write-Host "------------------------------------" -ForegroundColor Green

$path_arr=($env:path).split(";")
$path_arr

Write-Host "Changing ENV Variable: [HOME] " $computerName  -ForegroundColor Yellow
[System.Environment]::SetEnvironmentVariable('HOME','C:\Users\Wjb',[System.EnvironmentVariableTarget]::Machine)

Write-Host "------------------------------------" -ForegroundColor Green
Read-Host -Prompt "Setup is done, restart is needed, press [ENTER] to restart computer."
# Restart-Computer

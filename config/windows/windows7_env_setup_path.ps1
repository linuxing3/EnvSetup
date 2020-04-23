# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
# Unblock-File -Path .\windows7_env_setup_path.ps1
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Changing ENV Variable: [PATH]" $computerName  -ForegroundColor Yellow
Write-Host "------------------------------------" -ForegroundColor Green
$oldPath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
Write-Host "Old Value:" $oldPath  -ForegroundColor Green
Write-Host ""
Write-Host "------------------------------------" -ForegroundColor Green
$newPath = "C:\ProgramData\Anaconda3;C:\ProgramData\Anaconda3\Library\mingw-w64\bin;C:\ProgramData\Anaconda3\Library\usr\bin;C:\ProgramData\Anaconda3\Library\bin;C:\ProgramData\Anaconda3\Scripts;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files\ATI Technologies\ATI.ACE\Core-Static;C:\Program Files\Intel\iCLS Client\;C:\Program Files\Intel\Intel(R) Management Engine Components\DAL;C:\Program Files\Intel\Intel(R) Management Engine Components\IPT;C:\Program Files\NVIDIA Corporation\PhysX\Common;C:\Program Files\YUGUO;C:\ProgramData\chocolatey\bin;C:\Program Files\LLVM\bin;C:\Program Files\Git\cmd;C:\Program Files\Git\mingw32\bin;C:\Program Files\Git\usr\bin;C:\Users\wjb\AppData\Local\Programs\Microsoft VS Code\bin;C:\Program Files\Microsoft VS Code\bin;C:\Users\wjb\AppData\Roaming\nvm;C:\Program Files\nodejs;C:\Program Files\Yarn\bin\;C:\Users\wjb\AppData\Local\Yarn\bin;C:\Program Files\nodejs\node_modules\.bin;C:\Program Files\nodejs\node_modules\windows-build-tools\node_modules\.bin;C:\Users\wjb\AppData\Roaming\nvm\v10.15.3\node_modules\npm\node_modules\npm-lifecycle\node-gyp-bin;D:\vars\bin;D:\var\ctags58;D:\var\curl\bin;D:\var\pt;D:\var\rsync;D:\var\subl;D:\var\UltraISO;D:\Dropbox\bin;"


Write-Host "New Value:" $newPath  -ForegroundColor Green

Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath

Write-Host ""
Write-Host "------------------------------------" -ForegroundColor Green
($env:path).split(";")

Write-Host "Changing ENV Variable: [HOME] " $computerName  -ForegroundColor Yellow
[System.Environment]::SetEnvironmentVariable('HOME','C:\Users\Wjb',[System.EnvironmentVariableTarget]::Machine)

Write-Host "------------------------------------" -ForegroundColor Green
Read-Host -Prompt "Setup is done, restart is needed, press [ENTER] to restart computer."
# Restart-Computer

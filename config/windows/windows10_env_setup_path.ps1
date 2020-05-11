# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
# Unblock-File -Path .\windows7_env_setup_path.ps1
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$homedir="C:\Users\Wjb"
$drive="E:\"

$hasDrive = Get-PSDrive -Name H
if ($hasDrive.Name) {
  $drive="H:\"
}

Write-Host ""
Write-Host "Setting GOPATH AND GOROOT " $computerName  -ForegroundColor Yellow
Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "SET [GOPATH] to" $drive "workspace\gopath"  -ForegroundColor Yellow
Write-Host "SET [GOROOT] to" $drive "bin\go"  -ForegroundColor Yellow
[System.Environment]::SetEnvironmentVariable('GOPATH', $drive + 'workspace\gopath',[System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('GOROOT', $drive + 'bin\go',[System.EnvironmentVariableTarget]::Machine)


Write-Host "Setting Emacs server file " $computerName  -ForegroundColor Yellow
[System.Environment]::SetEnvironmentVariable('EMACS_SERVER_FILE', $HOME + '\.emacs.d\.local\cache\server\server',[System.EnvironmentVariableTarget]::Machine)

Write-Host "Setting NVM Environment variables " $computerName  -ForegroundColor Yellow
[System.Environment]::SetEnvironmentVariable('NVM_HOME', $HOME + '\AppData\Roaming\nvm',[System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('NVM_SYMBLINK', 'C:\Program Files\nodejs',[System.EnvironmentVariableTarget]::Machine)

# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Add [GOPATH] and [GOROOT] to PATH" $computerName  -ForegroundColor Yellow
write-host "Added [%GOROOT%\bin]" -ForegroundColor Yellow
write-host "Added [%GOPATH%\bin]" -ForegroundColor Yellow
Write-Host "------------------------------------" -ForegroundColor Green
$oldPath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
$newPath = $oldPath + "%GOROOT%\bin;%GOPATH%\bin;"
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath

Write-Host "------------------------------------" -ForegroundColor Green
Read-Host -Prompt "Installtion is done."

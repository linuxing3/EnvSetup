# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
# Unblock-File -Path .\windows7_env_setup_path.ps1
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

Write-Host ""
Write-Host "Setting GOPATH AND GOROOT " $computerName  -ForegroundColor Yellow
Write-Host "------------------------------------" -ForegroundColor Green
[System.Environment]::SetEnvironmentVariable('GOPATH','H:\workspace\gopath',[System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('GOROOT','H:\bin\go',[System.EnvironmentVariableTarget]::Machine)

# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Add [GOPATH] and [GOROOT] to PATH" $computerName  -ForegroundColor Yellow
Write-Host "------------------------------------" -ForegroundColor Green
$oldPath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path

$newPath = $oldPath + ";%GOROOT%\bin;%GOPATH%\bin"
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath

Write-Host "------------------------------------" -ForegroundColor Green
Read-Host -Prompt "Setup is done."

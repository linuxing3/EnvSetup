# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Add [GOPATH] and [GOROOT] to PATH" $computerName  -ForegroundColor Yellow
Write-Host "------------------------------------" -ForegroundColor Green

Write-Host "Setting emacs server file env variable" $computerName  -ForegroundColor Yellow
Write-Host "------------------------------------" -ForegroundColor Green
[System.Environment]::SetEnvironmentVariable('EMACS_SERVER_FILE', '%USERPROFILE%\.emacs.d\server\server',[System.EnvironmentVariableTarget]::Machine)

Write-Host "Setting emacsclient to open with menu item" $computerName  -ForegroundColor Yellow
Write-Host "------------------------------------" -ForegroundColor Green
$send_to_emacs_reg='Registry::HKEY_CLASSES_ROOT\directory\shell\Emacsclient'
$send_to_emacs_value = 'C:\ProgramData\chocolatey\lib\Emacs\tools\emacs\bin\emacsclientw.exe -n -c'
Set-ItemProperty -Path $send_to_emacs_reg -Name Command -Value $send_to_emacs_value


Write-Host "Setting emacs daemon to automatically run" $computerName  -ForegroundColor Yellow
Write-Host "------------------------------------" -ForegroundColor Green

$auto_run_reg = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
$auto_run_value = 'C:\Users\wjb\emacs-daemon.vbs'
Set-ItemProperty -Path $auto_run_reg -Name 'emacsdaemon' -Value $auto_run_value

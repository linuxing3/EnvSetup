Dim objShell
Set objShell = WScript.CreateObject( "WScript.Shell" )
objShell.run "C:\ProgramData\chocolatey\lib\Emacs\tools\emacs\bin\emacs.exe --daemon", 0, False
Set objShell = Nothing
$uri="https://github-production-release-asset-2e65be.s3.amazonaws.com/49609581/142d2280-5d5f-11ea-9cfe-fe02494447f7?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20200426%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20200426T161157Z&X-Amz-Expires=300&X-Amz-Signature=15fec1f00c2de40b0298d132a2170575189fd168c69ccb68cfc643cfb55d2fbd&X-Amz-SignedHeaders=host&actor_id=577637&repo_id=49609581&response-content-disposition=attachment%3B%20filename%3DPowerShell-7.0.0-win-x86.msi&response-content-type=application%2Foctet-stream"
$file "d:\powershell7.msi"
Invoke-WebRequest -Uri $uri -OutFile $file
d:\powershell7.msi

# GP_SysmonInstall

Powershell script used to deploy Sysmon to client PCs.  

This script relies on the Sysmon.exe, Sysmon64.exe, and config-client.xml files being hosted either on company server or external server.

Lines that should be modified:

Change the \\server to your domain fileserver hosting

Invoke-Expression "& 'C:\Temp\Sysmon.exe' -AcceptEula -I \\server\DomainFiles\config-client.xml"

Update the "8.00" to whatever version you are installing

if ((Get-Item "C:\Windows\Sysmon.exe").VersionInfo.FileVersion -ne "8.00") {

$sysmonService = Get-Service -Name Sysmon
$sysmonUrl32 = "https://live.sysinternals.com/sysmon.exe"
$sysmonUrl64 = "https://live.sysinternals.com/sysmon64.exe"
$tempPath = "C:\Temp\Sysmon.exe"

# Check for Temporary path existence
if (!(Test-Path -Path "C:\Temp")) { New-Item -ItemType Directory -Path "C:\Temp" }

# Get CPU architecture for proper download
$architecture = (Get-WmiObject -Class Win32_Processor | Select-Object Architecture)

if ($architecture.Architecture -eq 9) {
    Write-Host "Downloading 64bit version"
    (New-Object Net.WebClient).DownloadFile($sysmonUrl64, $tempPath)
} else {
    Write-Host "Downloading 32bit version"
    (New-Object Net.WebClient).DownloadFile($sysmonUrl32, $tempPath)
}

if (!$sysmonService) {
    Write-Host "Installing new service"
    Invoke-Expression "& 'C:\Temp\Sysmon.exe' -AcceptEula -I \\server\DomainFiles\config-client.xml"
} else {
    Write-Host "Checking installed version..."
    if ((Get-Item "C:\Windows\Sysmon.exe").VersionInfo.FileVersion -ne "8.00") {
            Write-Host "Uninstalling previous version"
            Invoke-Expression "& 'sysmon.exe' -u"
            Write-Host "Installing new version"
            Invoke-Expression "& 'C:\Temp\Sysmon.exe' -AcceptEula -I \\server\DomainFiles\config-client.xml"
        } else {
            Write-Host "Current Version Found, skipping install, updating config"
			Invoke-Expression "& 'sysmon.exe' -C \\server\DomainFiles\config-client.xml"
        }
}

if (Test-Path $tempPath) { Remove-Item -Path $tempPath }

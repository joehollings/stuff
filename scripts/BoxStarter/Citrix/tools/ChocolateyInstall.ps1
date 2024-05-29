Write-Verbose "Setting Arguments" -Verbose
$StartDTM = (Get-Date)

$Vendor = "Citrix"
$Product = "XenDesktop"
$PackageName = "Controller"
$InstallerType = "exe"
$Path = "D:\"
$Version = "7.18"
$LogPS = "${env:SystemRoot}" + "\Temp\$Vendor $Product $PackageName $Version PS Wrapper.log"
$LogApp = "${env:SystemRoot}" + "\Temp\$PackageName.log"
$UnattendedArgs = '/quiet /configure_firewall /COMPONENTS CONTROLLER /nosql /logpath $LogApp /noreboot'
$Destination = "$Path\x64\XenDesktop Setup\"

Start-Transcript $LogPS

CD $Destination
 
Write-Verbose "Starting Installation of $Vendor $Product $PackageName $Version" -Verbose
(Start-Process -FilePath "XenDesktopServerSetup.exe" -ArgumentList $unattendedArgs -Wait -Passthru).ExitCode

Write-Verbose "Customization" -Verbose

Write-Verbose "Stop logging" -Verbose
$EndDTM = (Get-Date)
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalSeconds) Seconds" -Verbose
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalMinutes) Minutes" -Verbose
Stop-Transcript

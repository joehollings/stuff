# Default Package variables
$Vendor = "Citrix"
$Product = "XenDesktop"
$PackageName = "Controller"
$Version = "7.18"
$LogPS = "${env:SystemRoot}" + "\Temp\$Vendor $Product $PackageName $Version PS Wrapper.log"
$LogApp = "${env:SystemRoot}" + "\Temp\$PackageName.log"

# Time in seconds the script waits for media to copy
$InstallLocation = "C:\Program Files\Citrix"
$Destination = "D:\x64\XenDesktop Setup\"
$UnattendedArgs = '/quiet /configure_firewall /COMPONENTS CONTROLLER /nosql /logpath $LogApp /noreboot'
$SetupFile = "XenDesktopServerSetup.exe"
$TestPath1 = Test-Path $InstallLocation

# Start logging
Write-Verbose "Setting Arguments" -Verbose
$StartDTM = (Get-Date)
Start-Transcript $LogPS

# Package code
# Tests if package is already installed
if ($TestPath1 -eq $false){
    
    CD $Destination
    
    Write-Verbose "Starting Installation of $Vendor $Product $PackageName $Version" -Verbose
    (Start-Process -FilePath $SetupFile -ArgumentList $UnattendedArgs -Wait -Passthru).ExitCode

}
else {
    Write-Verbose "Package is already installed" -Verbose
}
# End of package stop logging
Write-Verbose "Stop logging" -Verbose
$EndDTM = (Get-Date)
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalSeconds) Seconds" -Verbose
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalMinutes) Minutes" -Verbose
Stop-Transcript
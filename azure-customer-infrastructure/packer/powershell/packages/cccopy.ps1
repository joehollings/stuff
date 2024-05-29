# Default Package variables
$Vendor = "Citrix"
$Product = "DaaS"
$PackageName = "Cloud Connector"
$LogPS = "${env:SystemRoot}" + "\Temp\$Vendor $Product $PackageName PS Wrapper.log"
# Time in seconds the script waits for media to copy
$SetupFile = "cwcconnector.exe"
$Destination = "C:\Windows\Temp\CC\$SetupFile"
$TestPath = Test-Path $Destination
$MediaPath = "https://owscsafs01.file.core.windows.net/nas/Citrix/$SetupFile"

# Start logging
Write-Verbose "Setting Arguments" -Verbose
$StartDTM = (Get-Date)
Start-Transcript $LogPS

# Package code
# Tests if package is already installed
if ($TestPath -eq $false){
    # Tests if package install media has already been downloaded
    azcopy.exe copy $MediaPath$env:SAStoken $Destination    
    Write-Verbose "Download of $Vendor $Product $PackageName successful" -Verbose
}
else {
    Write-Verbose "Package is already downloaded" -Verbose
}
# End of package stop logging
Write-Verbose "Stop logging" -Verbose
$EndDTM = (Get-Date)
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalSeconds) Seconds" -Verbose
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalMinutes) Minutes" -Verbose
Stop-Transcript
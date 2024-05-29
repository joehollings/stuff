# Default Package variables
$Vendor = "Foxit"
$Product = "Reader"
$PackageName = "FoxitReader"
$Version = "9.7.1"
$LogPS = "${env:SystemRoot}" + "\Temp\$Vendor $Product $PackageName $Version PS Wrapper.log"
$MediaPath = "\\NCLMGTNAS01.mgmt.local\Media\Foxit"
$Destination = "C:\Windows\Temp\Foxit"
$SetupFile = "FoxitReader971_enu_Setup.msi"
$InstallLocation = "C:\Program Files (x86)\Foxit Software\Foxit Reader"
$TestPath1 = Test-Path $InstallLocation
$TestPath2 = Test-Path $Destination

# Start logging
Write-Verbose "Setting Arguments" -Verbose
$StartDTM = (Get-Date)
Start-Transcript $LogPS

# Package code
# Tests if package is already installed
if ($TestPath1 -eq $false){
    # Tests if package install media has already been downloaded
    if ($TestPath2 -eq $false){
      Copy-Item -Path $MediaPath -Destination $Destination -Recurse
      Start-Sleep -Seconds 60  
    }
    
    Write-Verbose "Starting Installation of $Vendor $Product $PackageName $Version" -Verbose
    msiexec /i "$Destination\$SetupFile" /q

    Write-Verbose "Cleaning up temp files" -Verbose

    Start-Sleep -Seconds 30

    Remove-Item -Path $Destination -Recurse -Force | Out-Null
    $TestPath = Test-Path $Destination
        if ($TestPath -eq $false){
            Write-Verbose "Temp files cleaned successfully" -Verbose
        }
        Else{
            Write-Verbose "unable to delete $Destination manual clean required" -Verbose
        }
    
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

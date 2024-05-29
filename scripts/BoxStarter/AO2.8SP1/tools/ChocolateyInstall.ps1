# Default Package variables
$Vendor = "SAP"
$Product = "Analysis Office"
$PackageName = "AO2.8SP1"
$Version = "2.8 SP1"
$LogPS = "${env:SystemRoot}" + "\Temp\$Vendor $Product $PackageName $Version PS Wrapper.log"
$MediaPath = "\\NCLMGTNAS01.mgmt.local\sap\AO2.8SP1"
# Time in seconds the script waits for media to copy
$MediaCopyWait = "5"
$InstallLocation = "C:\Program Files (x86)\SAP BusinessObjects\EPM Add-In"
$Destination = "C:\Windows\Temp\AO2.8SP1\"
$SetupFile = "AO2.8SP1.exe"
$unattendedArgs = '/Silent'
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
      Start-Sleep -Seconds $MediaCopyWait
    }
    
    Install-BoxstarterPackage VSTOR

    CD $Destination
    
    Write-Verbose "Starting Installation of $Vendor $Product $PackageName $Version" -Verbose
    (Start-Process -FilePath $SetupFile -ArgumentList $unattendedArgs -Wait -Passthru).ExitCode

    Write-Verbose "Cleaning up temp files" -Verbose

    CD "C:\Windows\System32"

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

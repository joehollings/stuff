# Default Package variables
$Vendor = "Microsoft"
$Product = "Office 2016 Pro Plus"
$PackageName = "Office2016ProPlus"
$Version = "32 bit"
$LogPS = "${env:SystemRoot}" + "\Temp\$Vendor $Product $PackageName $Version PS Wrapper.log"
$MediaPath = "\\NCLMGTNAS01.mgmt.local\Media\Microsoft\Office\Office 2016 ProPlus VL"
# Time in seconds the script waits for media to copy
$MediaCopyWait = "30"
$InstallLocation = "C:\Program Files (x86)\Microsoft Office\Office16\Configuration"
$Destination = "C:\Windows\Temp\Office 2016 ProPlus VL\"
$SetupFile = "Setup.exe"
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
    
    CD $Destination
    
    Write-Verbose "Starting Installation of $Vendor $Product $PackageName $Version" -Verbose
    (Start-Process -FilePath $SetupFile -Wait -Passthru).ExitCode

    Write-Verbose "Cleaning up temp files" -Verbose

    CD "C:\Windows\System32"

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

# Default Package variables
$Vendor = "Microsoft"
$Product = "Office 2019 Pro Plus"
$PackageName = "Office2019ProPlus"
$Version = "64 bit"
$LogPS = "${env:SystemRoot}" + "\Temp\$Vendor $Product $PackageName $Version PS Wrapper.log"
$MediaPath = "https://owscsafs01.file.core.windows.net/nas/microsoft/deploy/O2019ProPlusx64"
# Time in seconds the script waits for media to copy
$MediaCopyWait = "30"
$InstallLocation = "C:\Program Files\Microsoft Office"
$Destination = "C:\Windows\Temp\"
$MediaFolder = "O2019ProPlusx64"
$SetupFile = "Setup.exe"
$UnattendedArgs = "/configure configuration.xml"
$TestPath1 = Test-Path $InstallLocation
$TestPath2 = Test-Path "$Destination$MediaFolder"

# Start logging
Write-Verbose "Setting Arguments" -Verbose
$StartDTM = (Get-Date)
Start-Transcript $LogPS

# Package code
# Tests if package is already installed
if ($TestPath1 -eq $false){
    # Tests if package install media has already been downloaded
    if ($TestPath2 -eq $false){
        azcopy.exe copy $MediaPath$env:SAStoken $Destination --recursive
        Start-Sleep -Seconds $MediaCopyWait
        $Destination = "$Destination$MediaFolder"
    }
    
    Set-Location $Destination
    
    Write-Verbose "Starting Installation of $Vendor $Product $PackageName $Version" -Verbose
    (Start-Process -FilePath $SetupFile -ArgumentList $UnattendedArgs -Wait -Passthru).ExitCode

    Write-Verbose "Cleaning up temp files" -Verbose
    Start-Sleep -Seconds 30

    Set-Location "C:\Windows\System32"

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
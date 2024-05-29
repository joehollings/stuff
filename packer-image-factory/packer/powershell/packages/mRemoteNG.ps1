# Default Package variables
$Vendor = "mRemoteNG"
$Product = "mRemoteNG"
$PackageName = "mRemoteNG"
$Version = "1.76"
$LogPS = "${env:SystemRoot}" + "\Temp\$Vendor $Product $PackageName $Version PS Wrapper.log"
$InstallLocation = "C:\Program Files (x86)\mRemoteNG"
$SetupFile = "mRemoteNG.msi"
$Destination = "C:\Windows\Temp\mRemoteNG\$SetupFile"
$unattendedArgs = '/i mRemoteNG.msi /S /v/qn'
$TestPath1 = Test-Path $InstallLocation
$TestPath2 = Test-Path $Destination
$MediaPath = "https://owscsafs01.file.core.windows.net/nas/$SetupFile"

# Start logging
Write-Verbose "Setting Arguments" -Verbose
$StartDTM = (Get-Date)
Start-Transcript $LogPS

# Package code
# Tests if package is already installed
if ($TestPath1 -eq $false){
    # Tests if package install media has already been downloaded
    if ($TestPath2 -eq $false){
        azcopy.exe copy $MediaPath$env:SAStoken $Destination
    }
    
    $Destination = "C:\Windows\Temp\mRemoteNG\"
    Set-Location $Destination
    
    Write-Verbose "Starting Installation of $Vendor $Product $PackageName $Version" -Verbose
    (Start-Process msiexec.exe -ArgumentList $unattendedArgs -Wait -Passthru).ExitCode

    Write-Verbose "Cleaning up temp files" -Verbose

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
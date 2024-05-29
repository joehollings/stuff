$Vendor = "Citrix"
$Product = "XenDesktop"
$PackageName = "VDA"
$Version = "7.18"
$LogPS = "${env:SystemRoot}" + "\Temp\$Vendor $Product $PackageName $Version PS Wrapper.log"
$UnattendedArgs = '/quiet /enable_remote_assistance /virtualmachine /optimize /exclude "Citrix Personalization for App-V - VDA","Machine Identity Service","Personal vDisk"'
$Destination = "D:\x64\XenDesktop Setup\"
$SetupFile = "XenDesktopVDASetup.exe"
$State = Get-WindowsFeature RDS-RD-Server
$TestPath = Test-Path 'C:\Program Files\Citrix'  

Write-Verbose "Setting Arguments" -Verbose
$StartDTM = (Get-Date)
Start-Transcript $LogPS

if ($State.InstallState -eq "Installed"){
    if ($TestPath -eq $false){

        # This installs any prerequisites
        choco install vcredist140
        Install-BoxstarterPackage Office2016ProPlus
        Install-BoxstarterPackage SAPGUI
        Install-BoxstarterPackage ReaderDC
        
        CD $Destination
        
        Write-Verbose "Starting Installation of $Vendor $Product $PackageName $Version" -Verbose
        (Start-Process -FilePath $SetupFile -ArgumentList $unattendedArgs -Wait -Passthru).ExitCode
    }
    Else {
        Write-Verbose "Package is already installed" -Verbose  
    }
}

Else{
    Install-WindowsFeature RDS-RD-Server
    Invoke-Reboot
}

Write-Verbose "Stop logging" -Verbose
$EndDTM = (Get-Date)
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalSeconds) Seconds" -Verbose
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalMinutes) Minutes" -Verbose
Stop-Transcript

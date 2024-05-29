$Vendor = "Citrix"
$Product = "XenDesktop"
$PackageName = "VDA"
$Version = "7.15"
$LogPS = "${env:SystemRoot}" + "\Temp\$Vendor $Product $PackageName $Version PS Wrapper.log"
$UnattendedArgs = '/controllers "UKCLCTX01.BPC-Cloud.opalwave.local UKCLCTX02.BPC-Cloud.opalwave.local" /noreboot /quiet /enable_remote_assistance /disableexperiencemetrics /enable_hdx_ports /enable_hdx_udp_ports /exclude "Citrix Personalization for App-V - VDA","Machine Identity Service","Personal vDisk"'
$Destination = "D:\x64\XenDesktop Setup\"
$State = Get-WindowsFeature RDS-RD-Server
$TestPath = Test-Path 'C:\Program Files\Citrix'  

Write-Verbose "Setting Arguments" -Verbose
$StartDTM = (Get-Date)
Start-Transcript $LogPS

if ($State.InstallState -eq "Installed"){
    if ($TestPath -eq $false){
        
        # Install Apps
        Install-BoxstarterPackage Office2016ProPlus
        Install-BoxstarterPackage AO2.8SP1 -DisableReboots
        Install-BoxstarterPackage FoxitReader

        CD $Destination
        
        Write-Verbose "Starting Installation of $Vendor $Product $PackageName $Version" -Verbose
        Start-Process -FilePath "XenDesktopVDASetup.exe" -ArgumentList $unattendedArgs -Passthru
        Start-Sleep -Seconds 480
        Restart-Computer
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
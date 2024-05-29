# Default Package variables
$Vendor = "Citrix"
$Product = "XenDesktop"
$PackageName = "VDA2212"
$Version = "2212"
$LogPS = "${env:SystemRoot}" + "\Temp\$Vendor $Product $PackageName $Version PS Wrapper.log"
# Name of exe to download
$SetupFile = "VDAServerSetup_2212.exe"
# Location of setup exe. Needs to be an Azure File Share or an AWS S3 bucket
$MediaPath = "https://owscsafs01.file.core.windows.net/nas/Citrix/VDA Setup/"
# Installation path used for checking installation state
$InstallLocation = "C:\Program Files\Citrix"
# Temp location to store downloaded files
$Destination = "C:\Windows\Temp\"
# Name of folder containing Citrix files on source on destination
$MediaFolder = "VDA Setup"
# Parameters to use with exe for unattended installation
$unattendedArgs = '/noreboot /quiet /components VDA /masterimage /virtualmachine /optimize /enable_framehawk_port /enable_hdx_ports /enable_hdx_udp_ports /exclude "Citrix Telemetry Service","Citrix Personalization for App-V - VDA"'
# Used to check if package is already installed
$TestPath1 = Test-Path $InstallLocation
# Used to check if required files are download before installation starts
$TestPath2 = Test-Path "$Destination$MediaFolder"
# Name of Citrix Optimiser template to use
$CTX_OPT_XML_Name = "Citrix_Windows_10_2009.xml" 

# Start logging
Write-Verbose "Setting Arguments" -Verbose
$StartDTM = (Get-Date)
Start-Transcript $LogPS

# Package code
# Tests if package is already installed
if ($TestPath1 -eq $false){
    # Tests if package install media has already been downloaded
    if ($TestPath2 -eq $false){
        # Copies setup exe from Azure file share. Replace with SSM command to use with AWS S3 bucket.
        azcopy.exe copy $MediaPath$env:SAStoken $Destination --recursive
        $Destination = "$Destination$MediaFolder"
    }
    
    Set-Location "$Destination"
    
    Write-Verbose "Starting Installation of $Vendor $Product $PackageName $Version" -Verbose
    (Start-Process -FilePath $SetupFile -ArgumentList $unattendedArgs -Wait -Passthru).ExitCode   
}
else {
    Write-Verbose "Package is already installed" -Verbose
    $Destination = "$Destination$MediaFolder"
    Set-Location "$Destination"
    # Run Citrix Optimizer
    Write-Verbose "Running Citrix Optimizer"
    .\CitrixOptimizer\CtxOptimizerEngine.ps1 -Source "$Destination\CitrixOptimizer\Templates\$CTX_OPT_XML_Name" -Mode execute
    Write-Verbose "System optimised"
    Set-Location "C:\Windows\System32"
    # Clean up files
    Write-Verbose "Cleaning up temp files" -Verbose
    Remove-Item -Path "$Destination" -Recurse -Force
    $TestPath = Test-Path "$Destination"
        if ($TestPath -eq $false){
            Write-Verbose "Temp files cleaned successfully" -Verbose
        }
        Else{
            Write-Verbose "unable to delete $Destination manual clean required" -Verbose
        }
}

# End of package stop logging
Write-Verbose "Stop logging" -Verbose
$EndDTM = (Get-Date)
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalSeconds) Seconds" -Verbose
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalMinutes) Minutes" -Verbose
Stop-Transcript
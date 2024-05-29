$Source = "https://owscsafs01.file.core.windows.net/nas/Deploy"
$Destination = "c:\temp"
$filename = "azcopy.exe"
$ArgumentList = "copy $Source$env:SAStoken $Destination --recursive"

if (Test-Path ("$Destination\deploy\files.txt"))
{
	Write-Host "Files have already been downloaded successfully"
}
else
{
    Write-Host "Downloading Application files from NAS"
	mkdir $Destination
    $exit = (Start-Process ("$filename") -ArgumentList $ArgumentList -Wait -Verbose -Passthru).ExitCode
}

if ($exit -eq 0)
{
    if (Test-Path ("$Destination\deploy\files.txt"))
    {
        Write-Host "exiting..."
    }
    else
    {
        Get-Childitem -Path "$Destination\deploy" -Recurse| New-Item -Path "$Destination\deploy" -Name "files.txt"
	    Write-Host "Files have been downloaded successfully"
    }
}
else 
{
    Write-Host "File download has failed"
}
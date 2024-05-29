choco install -y packer
choco install -y git -params '"/GitAndUnixToolsOnPath"'
Install-Module -Name Az -Repository PSGallery -Force
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; Remove-Item .\AzureCLI.msi
Set-Location c:\
git clone https://github.com/actions/runner-images.git
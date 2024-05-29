Set-BoxstarterConfig -LocalRepo "\\NCLMGTNAS01.mgmt.local\Scripts\BoxStarter"
$update = Read-Host -Prompt "Install windows updates? Enter Y (Yes) or N (No)"

if ($update -eq "Y") {
    Install-WindowsUpdate
}
else {
    $Package = Read-Host -Prompt "Enter BoxStarter Package name"
    $UserName = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $cred=Get-Credential "$UserName"
    Install-BoxstarterPackage -PackageName $Package -Credential $cred
}

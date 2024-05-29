$Domain = "domain.local"
$username = "owscs\username"
$adminpassword = "" | ConvertTo-SecureString -AsPlainText -Force
$safemodepassword = "" | ConvertTo-SecureString -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $adminpassword)
Set-WinSystemLocale -SystemLocale en-GB
Set-WinDefaultInputMethodOverride -InputTip "0809:00000809"
Set-WinUILanguageOverride -Language en-GB
Set-WinHomeLocation -GeoId 0xF2
Set-Culture en-GB
Install-WindowsFeature AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools
Install-WindowsFeature DNS -IncludeAllSubFeature -IncludeManagementTools
Set-Volume -DriveLetter C -NewFileSystemLabel "System"
Install-ADDSDomainController -InstallDns -Credential $psCred -DomainName $Domain -SafeModeAdministratorPassword $safemodepassword -Force
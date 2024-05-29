Install-WindowsFeature AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools
Install-WindowsFeature DNS -IncludeAllSubFeature -IncludeManagementTools
Install-ADDSDomainController -InstallDns -Credential (Get-Credential "Morgan\opal-admin") -DomainName "Morgan.local" -Sitename "Morgan"

Install-ADDSDomain -Credential (Get-Credential OWSCS\joe.hollings.adm) -NewDomainName Morgan.local -DomainType TreeDomain -InstallDNS -CreateDNSDelegation -DomainMode Windows2016Domain
$Domain = "mottmac.local"
$Site = "AZR-OWSCS"
$dnsAddress = "10.10.4.6, 10.10.4.7"
$username = "owscs\joe.hollings.adm"
$password = ConvertTo-SecureString "jholl651984##" -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)


Add-Computer -DomainName $Domain -Credential $psCred

$nic = Get-NetAdapter
Set-DnsClientServerAddress -InterfaceIndex $nic.ifIndex -ServerAddresses $dnsAddress

Install-WindowsFeature AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools
Install-WindowsFeature DNS -IncludeAllSubFeature -IncludeManagementTools

# Pick option by removing #:

# 1) Install New Domain to existing Forest
Install-ADDSDomain -Credential $psCred -NewDomainName "mottmac.local" -DomainType TreeDomain -InstallDNS -SafeModeAdministratorPassword (ConvertTo-SecureString "0p4lw4v3@zur3" -AsPlainText -Force) -Force
# 2) Add DC to existing Domain
Install-ADDSDomainController -InstallDns -Credential $psCred -DomainName $Domain -Sitename $Site
#This script creates all of the AD objects and copies GPO's. Fill in the parmeters below.

#Enter server name of new tenant Domain Controller.
$ServerName = "AZR10017WDC01"
#Enter the tenant FQDN ie Domain.local.
$DomainName = "MOTTMAC.local"
$ServerName = "$ServerName.$DomainName"
#Enter the root OU for the domain, should be the same as the domain netbios name.
$OU = "MottMac"
#Don't change this one.
$Path = "OU=$OU,DC=$OU,DC=local" 
#Don't change this one.
$SourceDomain = "OWSCS.local"
$TargetDomain = $DomainName

#Groups--------------------------------------------------------------------------------------------------------------------------
New-ADOrganizationalUnit -Name "$OU" -Server $ServerName
New-ADOrganizationalUnit -Name "Groups" -Path "$Path" -Server $ServerName
New-ADOrganizationalUnit -Name "User Groups" -Path "OU=Groups,$Path" -Server $ServerName
New-ADOrganizationalUnit -Name "Infrastructure Groups" -Path "OU=Groups,$Path" -Server $ServerName
New-ADOrganizationalUnit -Name "Citrix" -Path "OU=Infrastructure Groups,OU=Groups,$Path" -Server $ServerName
New-ADOrganizationalUnit -Name "SAP" -Path "OU=Infrastructure Groups,OU=Groups,$Path" -Server $ServerName
New-ADOrganizationalUnit -Name "Applications" -Path "OU=Citrix,OU=Infrastructure Groups,OU=Groups,$Path" -Server $ServerName
New-ADOrganizationalUnit -Name "Delivery Groups" -Path "OU=Citrix,OU=Infrastructure Groups,OU=Groups,$Path" -Server $ServerName
#---------------------------------------------------------------------------------------------------------------------------------

#Servers--------------------------------------------------------------------------------------------------------------------------
New-ADOrganizationalUnit -Name "Servers" -Path "$Path" -Server $ServerName
New-ADOrganizationalUnit -Name "DEV Test" -Path "OU=Servers,$Path" -Server $ServerName
New-ADOrganizationalUnit -Name "Production" -Path "OU=Servers,$Path" -Server $ServerName
New-ADOrganizationalUnit -Name "Infrastructure" -Path "OU=Production,OU=Servers,$Path" -Server $ServerName
New-ADOrganizationalUnit -Name "SAP" -Path "OU=Production,OU=Servers,$Path" -Server $ServerName
New-ADOrganizationalUnit -Name "Citrix Cloud Prod" -Path "OU=Production,OU=Servers,$Path" -Server $ServerName
New-ADOrganizationalUnit -Name "Infrastructure" -Path "OU=DEV Test,OU=Servers,$Path" -Server $ServerName
New-ADOrganizationalUnit -Name "SAP" -Path "OU=DEV Test,OU=Servers,$Path" -Server $ServerName
New-ADOrganizationalUnit -Name "Citrix Cloud Dev" -Path "OU=DEV Test,OU=Servers,$Path" -Server $ServerName
#---------------------------------------------------------------------------------------------------------------------------------

#Users---------------------------------------------------------------------------------------------------
New-ADOrganizationalUnit -Name "Users" -Path "$Path" -Server $ServerName
New-ADOrganizationalUnit -Name "Administrators" -Path "OU=Users,$Path" -Server $ServerName
New-ADOrganizationalUnit -Name "BPC Users" -Path "OU=Users,$Path" -Server $ServerName
New-ADOrganizationalUnit -Name "Project Team" -Path "OU=BPC Users,OU=Users,$Path" -Server $ServerName
New-ADOrganizationalUnit -Name "$OU Users" -Path "OU=BPC Users,OU=Users,$Path" -Server $ServerName
New-ADOrganizationalUnit -Name "Service Accounts" -Path "OU=Users,$Path" -Server $ServerName
#--------------------------------------------------------------------------------------------------------

#Groups for Citrix------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
New-ADGroup -Name "DG_CTX_PRD" -GroupCategory Security -SamAccountName DG_CTX_PRD -GroupScope Global -Description "Citrix Production Delivery Group" -Path "OU=Delivery Groups,OU=Citrix,OU=Infrastructure Groups,OU=Groups,$Path" -Server $ServerName
New-ADGroup -Name "DG_CTX_TST" -GroupCategory Security -SamAccountName DG_CTX_TST -GroupScope Global -Description "Citrix Test Delivery Group" -Path "OU=Delivery Groups,OU=Citrix,OU=Infrastructure Groups,OU=Groups,$Path" -Server $ServerName
New-ADGroup -Name "DG_CTX_DEV" -GroupCategory Security -SamAccountName DG_CTX_DEV -GroupScope Global -Description "Citrix Dev Delivery Group" -Path "OU=Delivery Groups,OU=Citrix,OU=Infrastructure Groups,OU=Groups,$Path" -Server $ServerName
New-ADGroup -Name "APP_CTX_AO" -GroupCategory Security -SamAccountName APP_CTX_AO -GroupScope Global -Description "SAP AO Application Group" -Path "OU=Applications,OU=Citrix,OU=Infrastructure Groups,OU=Groups,$Path" -Server $ServerName
New-ADGroup -Name "APP_CTX_BPC_WEB" -GroupCategory Security -SamAccountName APP_CTX_BPC_WEB -GroupScope Global -Description "SAP BPC Web Application Group" -Path "OU=Applications,OU=Citrix,OU=Infrastructure Groups,OU=Groups,$Path" -Server $ServerName
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Copy GPO's------------------------------------------------------------------------------------------------------------------------------------------------------
Copy-GPO -SourceName "Admin User Settings" -SourceDomain $SourceDomain -TargetName "Admin User Settings" -TargetDomain $TargetDomain
Copy-GPO -SourceName "Automatic Certificate Enrollment" -SourceDomain $SourceDomain -TargetName "Automatic Certificate Enrollment" -TargetDomain $TargetDomain
Copy-GPO -SourceName "Default Server Policy" -SourceDomain $SourceDomain -TargetName "Default Server Policy" -TargetDomain $TargetDomain
Copy-GPO -SourceName "Domain Controllers NTP Policy" -SourceDomain $SourceDomain -TargetName "Domain Controllers NTP Policy" -TargetDomain $TargetDomain
Copy-GPO -SourceName "Member Server NTP Policy" -SourceDomain $SourceDomain -TargetName "Member Server NTP Policy" -TargetDomain $TargetDomain
Copy-GPO -SourceName "SAP Admins" -SourceDomain $SourceDomain -TargetName "NetWeaver Admins" -TargetDomain $TargetDomain
Copy-GPO -SourceName "VDA - All Users 1.0" -SourceDomain $SourceDomain -TargetName "VDA - All Users 1.0" -TargetDomain $TargetDomain
Copy-GPO -SourceName "VDA - Computers 1.0" -SourceDomain $SourceDomain -TargetName "VDA - Computers 1.0" -TargetDomain $TargetDomain
Copy-GPO -SourceName "VDA - IE 1.0" -SourceDomain $SourceDomain -TargetName "VDA - IE 1.0" -TargetDomain $TargetDomain
Copy-GPO -SourceName "VDA - Non Admin Users 1.0" -SourceDomain $SourceDomain -TargetName "VDA - Non Admin Users 1.0" -TargetDomain $TargetDomain
Copy-GPO -SourceName "VDA - RDS Licensing" -SourceDomain $SourceDomain -TargetName "VDA - RDS Licensing" -TargetDomain $TargetDomain
#----------------------------------------------------------------------------------------------------------------------------------------------------------------
#New OU's

#Groups-----------------------------------------------------------------------------------------------------------------------------------------------------------------
New-ADOrganizationalUnit -Name "Howden" -Server NCL10015WDC01.howden.local
New-ADOrganizationalUnit -Name "Groups" -Path "OU=Howden,DC=Howden,DC=Local" -Server NCL10015WDC01.howden.local
New-ADOrganizationalUnit -Name "User Groups" -Path "OU=Groups,OU=Howden,DC=Howden,DC=Local" -Server NCL10015WDC01.howden.local
New-ADOrganizationalUnit -Name "Infrastructure Groups" -Path "OU=Groups,OU=Howden,DC=Howden,DC=Local" -Server NCL10015WDC01.howden.local
New-ADOrganizationalUnit -Name "Citrix" -Path "OU=Infrastructure Groups,OU=Groups,OU=Howden,DC=Howden,DC=Local" -Server NCL10015WDC01.howden.local
New-ADOrganizationalUnit -Name "SAP" -Path "OU=Infrastructure Groups,OU=Groups,OU=Howden,DC=Howden,DC=Local" -Server NCL10015WDC01.howden.local
New-ADOrganizationalUnit -Name "Applications" -Path "OU=Citrix,OU=Infrastructure Groups,OU=Groups,OU=Howden,DC=Howden,DC=Local" -Server NCL10015WDC01.howden.local
New-ADOrganizationalUnit -Name "Delivery Groups" -Path "OU=Citrix,OU=Infrastructure Groups,OU=Groups,OU=Howden,DC=Howden,DC=Local" -Server NCL10015WDC01.howden.local
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Servers--------------------------------------------------------------------------------------------------------------------------
New-ADOrganizationalUnit -Name "Servers" -Path "OU=Howden,DC=Howden,DC=Local" -Server NCL10015WDC01.howden.local
New-ADOrganizationalUnit -Name "DEV Test" -Path "OU=Servers,OU=Howden,DC=Howden,DC=Local" -Server NCL10015WDC01.howden.local
New-ADOrganizationalUnit -Name "Production" -Path "OU=Servers,OU=Howden,DC=Howden,DC=Local" -Server NCL10015WDC01.howden.local
#---------------------------------------------------------------------------------------------------------------------------------

#Users------------------------------------------------------------------------------------------------------------------------------
New-ADOrganizationalUnit -Name "Users" -Path "OU=Howden,DC=Howden,DC=Local" -Server NCL10015WDC01.howden.local
New-ADOrganizationalUnit -Name "Administrators" -Path "OU=Users,OU=Howden,DC=Howden,DC=Local" -Server NCL10015WDC01.howden.local
New-ADOrganizationalUnit -Name "BPC Users" -Path "OU=Users,OU=Howden,DC=Howden,DC=Local" -Server NCL10015WDC01.howden.local
New-ADOrganizationalUnit -Name "Service Accounts" -Path "OU=Users,OU=Howden,DC=Howden,DC=Local" -Server NCL10015WDC01.howden.local
#------------------------------------------------------------------------------------------------------------------------------------

#Groups for Citrix-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
New-ADGroup -Name "DG_CTX_PRD" -GroupCategory Security -SamAccountName DG_CTX_PRD -GroupScope Global -Description "Citrix Production Delivery Group" -Path "OU=Delivery Groups,OU=Citrix,OU=Infrastructure Groups,OU=Groups,OU=Howden,DC=Howden,DC=Local" -Server NCL10015WDC01.howden.local
New-ADGroup -Name "APP_CTX_AO" -GroupCategory Security -SamAccountName APP_CTX_AO -GroupScope Global -Description "SAP AO Application Group" -Path "OU=Applications,OU=Citrix,OU=Infrastructure Groups,OU=Groups,OU=Howden,DC=Howden,DC=Local" -Server NCL10015WDC01.howden.local
New-ADGroup -Name "APP_CTX_BPC_WEB" -GroupCategory Security -SamAccountName APP_CTX_BPC_WEB -GroupScope Global -Description "SAP BPC Web Application Group" -Path "OU=Applications,OU=Citrix,OU=Infrastructure Groups,OU=Groups,OU=Howden,DC=Howden,DC=Local" -Server NCL10015WDC01.howden.local
New-ADGroup -Name "APP_CTX_BPC_WEB" -GroupCategory Security -SamAccountName APP_CTX_BPC_WEB -GroupScope Global -Description "SAP BPC Web Application Group" -Path "OU=Applications,OU=Citrix,OU=Infrastructure Groups,OU=Groups,OU=Howden,DC=Howden,DC=Local" -Server NCL10015WDC01.howden.local




#New-ADGroup -Name "GroupName" -GroupCategory Security -SamAccountName SAMAccountName -GroupScope Global -Description "Description" -Path "OU=Applications,OU=Citrix,OU=Infrastructure Groups,OU=Groups,OU=Howden,DC=Howden,DC=Local" -Server NCL10015WDC01.howden.local
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

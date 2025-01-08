$Domain = "customer"
$SAP_Password = "s@p1nst@ll3r!" | ConvertTo-SecureString -AsPlainText -Force
$SID1 = "" | ConvertTo-SecureString -AsPlainText -Force
#$SID2 = "" | ConvertTo-SecureString -AsPlainText -Force
$SID3 = "" | ConvertTo-SecureString -AsPlainText -Force

$CustomerNumber = "xxx"
$CustomerNumberFull = "10" + $CustomerNumber
$SAP_SID_Dev = "xx1"
#$SAP_SID_QAS = "xx2"
$SAP_SID_Prod = "xx3"

$OU = $Domain
$Path = "OU=$OU,DC=$OU,DC=local" 
$OU_Citrix = "OU=Citrix,OU=UK South,OU=Azure,OU=Servers,$Path"
$OU_Servers = "OU=Servers,$Path"
$OU_SAP = "OU=SAP,OU=UK South,OU=Azure,OU=Servers,$Path"
$AFSGroup = $CustomerNumberFull + " Azure Files Share Contributor"

#Groups---------------------------------------------------------------------------------------------------------------------------------------------------

New-ADOrganizationalUnit -Name "$OU" 
New-ADOrganizationalUnit -Name "Groups" -Path "$Path" 
New-ADOrganizationalUnit -Name "Infrastructure Groups" -Path "OU=Groups,$Path" 
New-ADOrganizationalUnit -Name "Azure" -Path "OU=Infrastructure Groups,OU=Groups,$Path" 
New-ADOrganizationalUnit -Name "Citrix" -Path "OU=Infrastructure Groups,OU=Groups,$Path" 
New-ADOrganizationalUnit -Name "Applications" -Path "OU=Citrix,OU=Infrastructure Groups,OU=Groups,$Path"
New-ADOrganizationalUnit -Name "Delivery Groups" -Path "OU=Citrix,OU=Infrastructure Groups,OU=Groups,$Path"
New-ADOrganizationalUnit -Name "SAP" -Path "OU=Infrastructure Groups,OU=Groups,$Path" 
New-ADOrganizationalUnit -Name "Resource Access Groups" -Path "OU=Groups,$Path" 
New-ADOrganizationalUnit -Name "User Groups" -Path "OU=Groups,$Path" 

#---------------------------------------------------------------------------------------------------------------------------------------------------------

#Servers--------------------------------------------------------------------------------------------------------------------------------------------------

New-ADOrganizationalUnit -Name "Servers" -Path "$Path" 
New-ADOrganizationalUnit -Name "Azure" -Path "OU=Servers,$Path" 
New-ADOrganizationalUnit -Name "UK South" -Path "OU=Azure,$OU_Servers" 
New-ADOrganizationalUnit -Name "Citrix" -Path "OU=UK South,OU=Azure,$OU_Servers" 
New-ADOrganizationalUnit -Name "VDA" -Path $OU_Citrix 
New-ADOrganizationalUnit -Name "Development" -Path "OU=VDA,$OU_Citrix" 
New-ADOrganizationalUnit -Name "Production" -Path "OU=VDA,$OU_Citrix" 
New-ADOrganizationalUnit -Name "Support" -Path "OU=VDA,$OU_Citrix" 
New-ADOrganizationalUnit -Name "SAP" -Path "OU=UK South,OU=Azure,$OU_Servers" 
New-ADOrganizationalUnit -Name "Development" -Path $OU_SAP 
New-ADOrganizationalUnit -Name "Production" -Path $OU_SAP 
New-ADOrganizationalUnit -Name "QAS" -Path $OU_SAP 

#---------------------------------------------------------------------------------------------------------------------------------------------------------

#Users----------------------------------------------------------------------------------------------------------------------------------------------------

New-ADOrganizationalUnit -Name "Users" -Path "$Path" 
New-ADOrganizationalUnit -Name "Administrators" -Path "OU=Users,$Path" 
New-ADOrganizationalUnit -Name "BPC Users" -Path "OU=Users,$Path" 
New-ADOrganizationalUnit -Name "Project Team" -Path "OU=BPC Users,OU=Users,$Path" 
New-ADOrganizationalUnit -Name "$OU Users" -Path "OU=BPC Users,OU=Users,$Path" 
New-ADOrganizationalUnit -Name "Service Accounts" -Path "OU=Users,$Path" 

#---------------------------------------------------------------------------------------------------------------------------------------------------------

#Groups----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

New-ADGroup -Name $AFSGroup -GroupCategory Security -SamAccountName $AFSGroup -GroupScope Global -Description "Azure Files RBAC Group" -Path "OU=Azure,OU=Infrastructure Groups,OU=Groups,$Path" 
New-ADGroup -Name "DG_CTX_PRD" -GroupCategory Security -SamAccountName DG_CTX_PRD -GroupScope Global -Description "Citrix Production Delivery Group" -Path "OU=Delivery Groups,OU=Citrix,OU=Infrastructure Groups,OU=Groups,$Path" 
New-ADGroup -Name "DG_CTX_TST" -GroupCategory Security -SamAccountName DG_CTX_TST -GroupScope Global -Description "Citrix Test Delivery Group" -Path "OU=Delivery Groups,OU=Citrix,OU=Infrastructure Groups,OU=Groups,$Path" 
New-ADGroup -Name "DG_CTX_DEV" -GroupCategory Security -SamAccountName DG_CTX_DEV -GroupScope Global -Description "Citrix Dev Delivery Group" -Path "OU=Delivery Groups,OU=Citrix,OU=Infrastructure Groups,OU=Groups,$Path" 

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#User and Machine Accounts---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# SAP Service accounts----------------------------------------------------------------

# Dev --------------------------------------------------------------------------------

$SAP_Global_Admin_Dev = "SAP_" + $SAP_SID_Dev + "_GlobalAdmin"
$SAP_Service_Dev = "SAPService" + $SAP_SID_Dev
$SAP_ADM_Dev = $SAP_SID_Dev + "adm"
$SAP_SSO_Dev = "SL-ABAP-" + $SAP_SID_Dev
$SPN_SSO_Dev_ABAP = "SAP/SL-ABAP-" + $SAP_SID_Dev
$SPN_SSO_Dev_Hostname = "HTTP/az" + $CustomerNumber + $SAP_SID_Dev + "sap01"
$SPN_SSO_Dev_FQDN = "HTTP/az" + $CustomerNumber + $SAP_SID_Dev + "sap01." + $DomainName

# QAS ---------------------------------------------------------------------------------

$SAP_Global_Admin_QAS = "SAP_" + $SAP_SID_QAS + "_GlobalAdmin"
$SAP_Service_QAS = "SAPService" + $SAP_SID_QAS
$SAP_ADM_QAS = $SAP_SID_QAS + "adm"
$SAP_SSO_QAS = "SL-ABAP-" + $SAP_SID_QAS
$SPN_SSO_QAS_ABAP = "SAP/SL-ABAP-" + $SAP_SID_QAS
$SPN_SSO_QAS_Hostname = "HTTP/az" + $CustomerNumber + $SAP_SID_QAS + "sap01"
$SPN_SSO_QAS_FQDN = "HTTP/az" + $CustomerNumber + $SAP_SID_QAS + "sap01." + $DomainName
$SAP_SSO_Prod = "SL-ABAP-" + $SAP_SID_Prod

# Prod ----------------------------------------------------------------------------------

$SAP_Global_Admin_Prod = "SAP_" + $SAP_SID_Prod + "_GlobalAdmin"
$SAP_Service_Prod = "SAPService" + $SAP_SID_Prod
$SAP_ADM_Prod = $SAP_SID_Prod + "adm"
$SPN_SSO_Prod_ABAP = "SAP/SL-ABAP-" + $SAP_SID_Prod
$SPN_SSO_Prod_Hostname = "HTTP/az" + $CustomerNumber + $SAP_SID_Prod + "sap01"
$SPN_SSO_Prod_FQDN = "HTTP/az" + $CustomerNumber + $SAP_SID_Prod + "sap01." + $DomainName

#-----------------------------------------------------------------------------------------

# Dev Service accounts ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$UPN = $SAP_Service_Dev + "@$DomainName"
$Description = "SAP Development System Service Account"
New-ADUser -Name $SAP_Service_Dev -DisplayName $SAP_Service_Dev -SamAccountName $SAP_Service_Dev -UserPrincipalName $UPN -Description $Description -AccountPassword $SID1 -PasswordNeverExpires $true -Enabled $true 

$UPN = $SAP_ADM_Dev + "@$DomainName"
$Description = "SAP Development System ADM Account"
New-ADUser -Name $SAP_ADM_Dev -DisplayName $SAP_ADM_Dev -SamAccountName $SAP_ADM_Dev -UserPrincipalName $UPN -Description $Description -AccountPassword $SID1 -PasswordNeverExpires $true -Enabled $true 

$UPN = $SAP_SSO_Dev + "@$DomainName"
$Description = "SAP Development System SSO Service account"
$UserOU = "OU=Service Account,OU=Users,$Path"
New-ADUser -Name $SAP_SSO_Dev -DisplayName $SAP_SSO_Dev -SamAccountName $SAP_SSO_Dev -UserPrincipalName $UPN -Description $Description -AccountPassword $SID1 -PasswordNeverExpires $true -Enabled $true -ServicePrincipalNames $SPN_SSO_Dev_ABAP, $SPN_SSO_Dev_Hostname, $SPN_SSO_Dev_FQDN

New-ADGroup -Name $SAP_Global_Admin_Dev -GroupCategory Security -SamAccountName $SAP_Global_Admin_Dev -GroupScope Global -Description "SAP development system Global Admin group" 
Add-ADGroupMember -Identity $SAP_Global_Admin_Dev -Members $SAP_ADM_Dev,$SAP_Service_Dev 

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# QAS Service accounts ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$UPN = $SAP_Service_QAS + "@$DomainName"
$Description = "SAP QAS System Service Account"
New-ADUser -Name $SAP_Service_QAS -DisplayName $SAP_Service_QAS -SamAccountName $SAP_Service_QAS -UserPrincipalName $UPN -Description $Description -AccountPassword $SID2 -PasswordNeverExpires $true -Enabled $true 

$UPN = $SAP_ADM_QAS + "@$DomainName"
$Description = "SAP Test System ADM Account"
New-ADUser -Name $SAP_ADM_QAS -DisplayName $SAP_ADM_QAS -SamAccountName $SAP_ADM_QAS -UserPrincipalName $UPN -Description $Description -AccountPassword $SID2 -PasswordNeverExpires $true -Enabled $true 

$UPN = $SAP_SSO_QAS + "@$DomainName"
$Description = "SAP QAS System SSO Service account"
$UserOU = "OU=Service Account,OU=Users,$Path"
New-ADUser -Name $SAP_SSO_QAS -DisplayName $SAP_SSO_QAS -SamAccountName $SAP_SSO_QAS -UserPrincipalName $UPN -Description $Description -AccountPassword $SID2 -PasswordNeverExpires $true -Enabled $true -ServicePrincipalNames $SPN_SSO_QAS_ABAP, $SPN_SSO_QAS_Hostname, $SPN_SSO_QAS_FQDN

New-ADGroup -Name $SAP_Global_Admin_QAS -GroupCategory Security -SamAccountName $SAP_Global_Admin_QAS -GroupScope Global -Description "SAP test system Global Admin group" 
Add-ADGroupMember -Identity $SAP_Global_Admin_QAS -Members $SAP_ADM_QAS,$SAP_Service_QAS 

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Prod Service accounts-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$UPN = $SAP_Service_Prod + "@$DomainName"
$Description = "SAP Production System Service Account"
New-ADUser -Name $SAP_Service_Prod -DisplayName $SAP_Service_Prod -SamAccountName $SAP_Service_Prod -UserPrincipalName $UPN -Description $Description -AccountPassword $SID3 -PasswordNeverExpires $true -Enabled $true 

$UPN = $SAP_ADM_Prod + "@$DomainName"
$Description = "SAP Production System ADM Account"
New-ADUser -Name $SAP_ADM_Prod -DisplayName $SAP_ADM_Prod -SamAccountName $SAP_ADM_Prod -UserPrincipalName $UPN -Description $Description -AccountPassword $SID3 -PasswordNeverExpires $true -Enabled $true 

$UPN = $SAP_SSO_Prod + "@$DomainName"
$Description = "SAP Development System SSO Service account"
$UserOU = "OU=Service Account,OU=Users,$Path"
New-ADUser -Name $SAP_SSO_Prod -DisplayName $SAP_SSO_Prod -SamAccountName $SAP_SSO_Prod -UserPrincipalName $UPN -Description $Description -AccountPassword $SID3 -PasswordNeverExpires $true -Enabled $true -ServicePrincipalNames $SPN_SSO_Prod_ABAP, $SPN_SSO_Prod_Hostname, $SPN_SSO_Prod_FQDN

New-ADGroup -Name $SAP_Global_Admin_Prod -GroupCategory Security -SamAccountName $SAP_Global_Admin_Prod -GroupScope Global -Description "SAP production system Global Admin group" 
Add-ADGroupMember -Identity $SAP_Global_Admin_Prod -Members $SAP_ADM_Prod,$SAP_Service_Prod 

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# SAP installer account------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$Displayname = "SAPInst"
$UserOU = "OU=Administrators,OU=Users,$Path"
$SAM = "sapinst"
$UPN = $SAM + "@$Domain"
$Description = "SAP installer account"
New-ADUser -Name "$Displayname" -DisplayName "$Displayname" -SamAccountName $SAM -UserPrincipalName $UPN -Description "$Description" -AccountPassword $SAP_Password -PasswordNeverExpires $true -Enabled $true -Path "$UserOU" 

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Secondary DC--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
$Name = "az" + $CustomerNumber + "wdc02"
New-ADComputer -Name $Name -SAMAccountName $Name -Path $OU_Servers
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Citrix Cloud Connectors----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$Name = "az" + $CustomerNumber + "ccc01"
New-ADComputer -Name $Name -SAMAccountName $Name -Path $OU_Citrix
$Name = "az" + $CustomerNumber + "ccc02"
New-ADComputer -Name $Name -SAMAccountName $Name -Path $OU_Citrix

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# BPC Application servers----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$Name = "az" + $CustomerNumber + $SAP_SID_Dev + "sap01"
New-ADComputer -Name $Name -SAMAccountName $Name -Path "OU=Development,OU=SAP,OU=UK South,OU=Azure,OU=Servers,$Path"
# $Name = "az" + $CustomerNumber + $SAP_SID_QAS + "sap01"
# New-ADComputer -Name $Name -SAMAccountName $Name -Path "OU=QAS,OU=SAP,OU=UK South,OU=Azure,OU=Servers,$Path"
$Name = "az" + $CustomerNumber + $SAP_SID_Prod + "sap01"
New-ADComputer -Name $Name -SAMAccountName $Name -Path "OU=Production,OU=SAP,OU=UK South,OU=Azure,OU=Servers,$Path"

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# VDA Templates--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$Name = "az" + $CustomerNumber + "vdadev01"
New-ADComputer -Name $Name -SAMAccountName $Name -Path "OU=VDA,$OU_Citrix"
$Name = "az" + $CustomerNumber + "vdaprod01"
New-ADComputer -Name $Name -SAMAccountName $Name -Path "OU=VDA,$OU_Citrix"

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Link GPO's ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Remove-GPLink -Name "Default Domain Policy" -Target "DC=$OU,DC=local"
New-GPLink -Name "Computer - Password Policy" -Domain "owscs.local" -Target "DC=$OU,DC=local"
New-GPLink -Name "Computer - Domain Controllers NTP 1.0" -Domain "owscs.local" -Target "OU=Domain Controllers,DC=$OU,DC=local" 
New-GPLink -Name "Computer - Automatic Certificate Enrollment 1.0" -Domain "owscs.local" -Target $OU_Servers
New-GPLink -Name "Computer - Default Config 1.0" -Domain "owscs.local" -Target $OU_Servers
New-GPLink -Name "Computer - Member Server NTP 1.0" -Domain "owscs.local" -Target $OU_Servers 
New-GPLink -Name "Computer - Windows Defender 1.0" -Domain "owscs.local" -Target $OU_Servers 
New-GPLink -Name "User - Admin Users 1.0" -Domain "owscs.local" -Target "$Path" 
New-GPLink -Name "User - Azure File Shares 1.0" -Domain "owscs.local" -Target $OU_Servers
#New-GPO -Name "Computer - Citrix FAS" | New-GPLink -Target $OU_Citrix -LinkEnabled Yes
New-GPLink -Name "Computer - Browser 1.0" -Domain "owscs.local" -Target "OU=VDA,$OU_Citrix" 
#New-GPLink -Name "Computer - Office 2016 1.0" -Domain "owscs.local" -Target "OU=VDA,$OU_Citrix"
New-GPLink -Name "User - Browser 1.0" -Domain "owscs.local" -Target "OU=VDA,$OU_Citrix" 
New-GPLink -Name "User - Office 2016 1.0" -Domain "owscs.local" -Target "OU=VDA,$OU_Citrix"
New-GPLink -Name "VDA - All Users 1.0" -Domain "owscs.local" -Target "OU=VDA,$OU_Citrix" 
New-GPLink -Name "VDA - Computers 1.0" -Domain "owscs.local" -Target "OU=VDA,$OU_Citrix"
New-GPLink -Name "VDA - Load AO 2.8" -Domain "owscs.local" -Target "OU=VDA,$OU_Citrix"
New-GPLink -Name "VDA - Non Admin Users 1.0" -Domain "owscs.local" -Target "OU=VDA,$OU_Citrix" 
New-GPO -Name "VDA - Profile Management" | New-GPLink -Target "OU=VDA,$OU_Citrix" -LinkEnabled Yes 
New-GPLink -Name "User - SAP Admins 1.0" -Domain "owscs.local" -Target $OU_SAP 
New-GPO -Name "User - SAP Service Accounts 1.0" | New-GPLink -Target $OU_SAP -LinkEnabled Yes 

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
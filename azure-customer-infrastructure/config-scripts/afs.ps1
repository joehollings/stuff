$CustomerNumber = "10xxx"
$StorageAccountName = $CustomerNumber + "afs01"
$ResourceGroupName = $CustomerNumber + "-rsg-prod"
$OUpath = "OU=AFS,OU=Azure,OU=Servers,OU=OWSCS,DC=OWSCS,DC=local"
$SPN = "cifs/$StorageAccountName.file.core.windows.net"
$Description = "Computer account object for Azure storage account $StorageAccountName."
New-ADComputer -Name $StorageAccountName -SAMAccountName $StorageAccountName -Description $Description -ServicePrincipalNames $SPN -Path $OUpath
$ObjectSID=(Get-ADComputer $StorageAccountName).SID.Value
$ObjectSID

# connect to azure
Connect-AzAccount

# create kerberos storage account key and retrieve storage account key
New-AzStorageAccountKey -ResourceGroupName $ResourceGroupName -Name $StorageAccountName -KeyName kerb1
$AccountKey = Get-AzStorageAccountKey -ResourceGroupName $ResourceGroupName -Name $StorageAccountName -ListKerbKey | where-object{$_.Keyname -contains "kerb1"}
$AccountKey = $AccountKey.Value
$Identity = "$StorageAccountName" + "$"
# set storage account key as password on service account
Set-ADAccountPassword -Identity $Identity -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $AccountKey -Force)


# Get storage account info
# get-AzStorageAccount `
#         -ResourceGroupName $ResourceGroupName `
#         -Name $StorageAccountName 

# Use to manually fix storage account
# Set-AzStorageAccount `
#         -ResourceGroupName $ResourceGroupName `
#         -Name $StorageAccountName `
#         -EnableActiveDirectoryDomainServicesForFile $false
# Set-AzStorageAccount `
#         -ResourceGroupName $ResourceGroupName `
#         -Name $StorageAccountName `
#         -EnableActiveDirectoryDomainServicesForFile $true `
#         -ActiveDirectoryDomainName $ADDomainName `
#         -ActiveDirectoryNetBiosDomainName $ADNetbios `
#         -ActiveDirectoryForestName $ADForest `
#         -ActiveDirectoryDomainGuid $DomainGUID `
#         -ActiveDirectoryDomainsid $DomainSID `
#         -ActiveDirectoryAzureStorageSid $ObjectSID

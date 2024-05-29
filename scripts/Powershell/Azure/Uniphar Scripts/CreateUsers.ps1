$Description = "Created by DJ on 12-05-23"
$OU = "OU=Uniphar Users,OU=BPC Users,OU=Users,OU=Uniphar,DC=uniphar,DC=local"
$Password = "UN!ph@rC1trix.2023"


$Users = Import-Csv -Path "C:\Script\UniUsers.csv"
foreach ($User in $Users)
{
    $Displayname = $User.'Firstname' + " " + $User.'Surname'
    $UserFirstname = $User.'Firstname'
    $UserLastname = $User.'Surname'
    $SAM = $User.'SamAccountName'
    $UPN = $User.'UPN'
    $HomeDrive = $User.'HomeDrive'
    $HomeDirectory = $User.'HomeDirectory'
    $EmailAddress = $User.'EmailAddress'

 New-ADUser -Name "$Displayname" -DisplayName "$Displayname" -SamAccountName $SAM -UserPrincipalName $UPN -GivenName "$UserFirstname" -Surname "$UserLastname" -Description "$Description" -HomeDrive "$HomeDrive" -HomeDirectory "$HomeDirectory" -EmailAddress "$EmailAddress" -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -ChangePasswordAtLogon $false -PasswordNeverExpires $true -Enabled $true -Path "$OU" -server uniphar.local

}

Add-ADGroupMember -Identity DG_CTX_PRD -Members $users.samaccountname -server uniphar.local
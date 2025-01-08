$users = Get-Content -Path "path to csv file"
$server = "\\server\share"

foreach ($user in $users){
$HomeDir ="$server\$user"
$domain=((gwmi Win32_ComputerSystem).Domain).Split(".")[0]
# Sets homedir in AD profile	
#Set-ADUser $user -HomeDirectory $HomeDir -HomeDrive h

# Check if home folder exists and creates if not
if (-not (Test-Path "$homedir")){
    $acl = Get-Acl (New-Item -Path $homedir -ItemType Directory)
    # Make sure access rules inherited from parent folders.
    $acl.SetAccessRuleProtection($false, $true)
    $ace = "$domain\$user","FullControl", "ContainerInherit,ObjectInherit","None","Allow"
    $objACE = New-Object System.Security.AccessControl.FileSystemAccessRule($ace)
    $acl.AddAccessRule($objACE)
    Set-ACL -Path "$homedir" -AclObject $acl
 }
}
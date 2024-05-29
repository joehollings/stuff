$path = "OU=Uniphar Users,OU=BPC Users,OU=Users,OU=Uniphar,DC=uniphar,DC=local"
$users = get-aduser -SearchBase $path -filter * -properties name -server uniphar.local

foreach ($User in $Users.samaccountname)
{

$srcpath = "C:\Script\Migrate\" + $user
$dstpath = "Z:\home\" + $user

robocopy $srcpath $dstpath /e

}
## Clear any existing credentials
#Clear-AWSCredential

## Set credentials to required IAM user
#Set-AWSCredential -ProfileName my_iam_role_new

## Create temporary credentials for the IAM user with MFA
$token= Read-Host -Prompt "Enter you MFA code" -AsSecureString
$sCreds = Get-STSSessionToken -DurationInSeconds 36000 -SerialNumber arn:aws:iam::040572446079:mfa/dean.johnson@sapphiresystems -TokenCode $token
## Set the temporary credentials as default

"CustomerName,AccountID,Status" > C:\Script\AccountAccess.log

$customers = Import-Csv -Path "C:\Script\AllAccounts_NEW.csv"
foreach ($customer in $customers)
{
    $customername = $customer.'CustomerName'
    $accountid = $customer.'AccountID'

        Get-Variable -Exclude accountid,defaultregion,customername,sCreds | Remove-Variable -EA 0
        

        #$accountid = "782989141828"
        #$customername = "Precision Refrigeration Limited"

        Clear-AWSCredential
        ## Reset Credentials
        Set-AWSCredentials -Credential $sCreds

        ##Assume role
        $credout =""
        $Creds= ""        
        Try {$Creds = (Use-STSRole -RoleArn "arn:aws:iam::$($accountid):role/OrganizationAccountAccessRole" -RoleSessionName "DJ").credentials}
        Catch {$customername + ",# " + $accountid + "," + "Error Connecting to Account" >> C:\Script\AccountAccess.log}

        if ($Creds)
        {

        Set-AWSCredentials -Credential $Creds
        $customername + ",# " + $accountid + "," + "OK"  >> C:\Script\AccountAccess.log

        

        
    } else {}



}




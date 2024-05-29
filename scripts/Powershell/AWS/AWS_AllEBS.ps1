

##################################################
### This section should be run once at the     ###
### beginning to set credentials. Not required ###
### for subsequent executions                  ###
###                                            ### 
### The four lines can be commented out        ###
##################################################


## Clear any existing credentials
#Clear-AWSCredential

## Set credentials to required IAM user
#Set-AWSCredential -ProfileName my_iam_role

## Create temporary credentials for the IAM user with MFA
#$token= Read-Host -Prompt "Enter you MFA code"
#$sCreds = Get-STSSessionToken -DurationInSeconds 36000 -SerialNumber arn:aws:iam::040572446079:mfa/dean.johnson@sapphiresystems -TokenCode $token
## Set the temporary credentials as default

##################################################
### End of credential section                  ###
##################################################

$date = Get-Date -format "dd.MM.yyyy"

        $ExcelObj = New-Object -comobject Excel.Application
        $ExcelObj.visible=$true
        $ExcelWorkBook = $ExcelObj.Workbooks.Add()
        $ExcelWorkBook.Sheets| fl Name, index
        $ExcelWorkSheet = $ExcelWorkBook.Worksheets.Item(1)

        $ExcelWorkSheet.Range(“A1”) = "Device Name"
        $ExcelWorkSheet.Range(“B1”) = "Attached VM"
        $ExcelWorkSheet.Range(“C1”) = "Size"
        $ExcelWorkSheet.Range(“D1”) = "Iops"
        $ExcelWorkSheet.Range(“E1”) = "Volume Type"
        $ExcelWorkSheet.Range(“F1”) = "Encrypted"
        $ExcelWorkSheet.Range(“G1”) = "VolumeID"
        $ExcelWorkSheet.Range(“H1”) = "AZ"
        $ExcelWorkSheet.Range(“I1”) = "CustomerID"
        $ExcelWorkSheet.Range(“J1”) = " Customer Name"

        $i=2

                $customers = Import-Csv -Path "C:\Script\AllAccounts.csv"
                foreach ($customer in $customers)
                {

                    $customername = $customer.'CustomerName'
                    $accountid = $customer.'AccountID'

                    ## Reset Credentials
                    Set-AWSCredentials -Credential $sCreds

                    ##Clear Creds variable
                    $Creds = ""
                    ## Assume a role in customer account using the temporary MFA credentials
                    $Creds = (Use-STSRole -RoleArn "arn:aws:iam::$($accountid):role/OrganizationAccountAccessRole" -RoleSessionName "DJ").credentials
        
                    if ($creds)
                    {

                    Set-AWSCredentials -Credential $Creds

                    $regions = Get-ec2region

                    ## Set counter to 0
                    $r=0

                    ## Loop for each
                    Foreach ($region in $regions) 
                    {

                    $regionused = ""
                    $vpccount = ""
            
                    Set-DefaultAWSRegion -Region $region.regionname
                    $vpccount = (get-ec2volume).length
            
                    if ($vpccount -gt 0) 
                    {
                        


                    ## Get Disks
                    $disks = get-ec2volume
                    
                    ## Set counter to 0
                    

                    ## For each loop
                    Foreach ($disk in $disks) {

                        $vm = ""
                        $ec2LogicalName = ""
                              
                        $vmid = $disk.attachments.InstanceId
        
                        if ($vmid) {$vm = (Get-EC2Instance -InstanceId $vmid).Instances} else {}
           
                        $tags = $vm.Tags
	                    if(!([string]::IsNullOrEmpty($tags)))
                            {
	      	                    if($tags.Key -eq "Name"){$ec2LogicalName =  $tags | Where-Object { $_.Key -eq "Name" } | Select-Object -expand Value}   
	                        }

                        ## Write values to table
                        $ExcelWorkSheet.Range(“A"+$i) = [string]$disk.Attachment.Device
                        $ExcelWorkSheet.Range(“B"+$i) = [string]$ec2LogicalName
                        $ExcelWorkSheet.Range(“C"+$i) = [string]$disk.Size
                        $ExcelWorkSheet.Range(“D"+$i) = [string]$disk.Iops
                        $ExcelWorkSheet.Range(“E"+$i) = [string]$disk.VolumeType
                        $ExcelWorkSheet.Range(“F"+$i) = [string]$disk.Encrypted
                        $ExcelWorkSheet.Range(“G"+$i) = [string]$disk.Volumeid
                        $ExcelWorkSheet.Range(“H"+$i) = [string]$disk.AvailabilityZone
                        $ExcelWorkSheet.Range(“I"+$i) = [string]$accountid
                        $ExcelWorkSheet.Range(“J"+$i) = [string]$customername

                    ## Increment counter
                    $i++
                    }
                    }
                    }                   
                    } else {"No Access to account"}
                    }

                        
        #$file = "C:\Script\Reports\AWS-Documentation-" + $customername.ToUpper() + ".docx"
        #[ref]$SaveFormat = “microsoft.office.interop.word.WdSaveFormat” -as [type]
        #$document.saveas([ref] $file, [ref]$SaveFormat::wdFormatDocumentDefault)
        #$document.Close()
        #$word.Quit()

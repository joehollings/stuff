

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

        $ExcelWorkSheet.Range(“A1”) = "VM Name"
        $ExcelWorkSheet.Range(“B1”) = "Instance ID"
        $ExcelWorkSheet.Range(“C1”) = "Status"
        $ExcelWorkSheet.Range(“D1”) = "IP Address"
        $ExcelWorkSheet.Range(“E1”) = "CustomerID"
        $ExcelWorkSheet.Range(“F1”) = " Customer Name"

        $i=2

                $customers = Import-Csv -Path "C:\Script\NEWAllAccounts.csv"
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
                    $vpccount = (get-ec2instance).length
            
                    if ($vpccount -gt 0) 
                    {
                        


                        ## Get VMs
                        $VMs = ""
                        $VMs = Get-EC2Instance | Select-Object Instances -ExpandProperty Instances
                    
                    ## Set counter to 0
                    

                    ## Loop for each
                            Foreach ($VM in $VMs) {

                                    $ec2LogicalName = ""
                                    $subnetname = ""
                            
                                    $tags = $VM.Tags
	                                if(!([string]::IsNullOrEmpty($tags)))
                                        {
	        	                            if($tags.Key -eq "Name"){$ec2LogicalName =  $tags | Where-Object { $_.Key -eq "Name" } | Select-Object -expand Value}   
	                                    }
            
                                    $vmdisks = get-ec2volume -filter @{name='attachment.instance-id';values=$VM.InstanceId}

                                    $launchtime = [String]$VM.LaunchTime

                                    $subnet = get-ec2subnet -SubnetId $vm.networkinterfaces.subnetid

                                    $tags = $subnet.Tags
	                                if(!([string]::IsNullOrEmpty($tags)))
                                        {
	        	                            if($tags.Key -eq "Name"){$subnetname =  $tags | Where-Object { $_.Key -eq "Name" } | Select-Object -expand Value}   
	                                    }

                                    $azdetails = Get-EC2AvailabilityZone -ZoneName $vm.placement.AvailabilityZone

                                    ## Write values to table
                                    $ExcelWorkSheet.Range(“A"+$i) = [string]$ec2LogicalName
                                    $ExcelWorkSheet.Range(“B"+$i) = [string]$VM.InstanceId
                                    $ExcelWorkSheet.Range(“C"+$i) = [string]$VM.State.Name.value
                                    $ExcelWorkSheet.Range(“D"+$i) = [string]$VM.PrivateIpAddress
                                    $ExcelWorkSheet.Range(“E"+$i) = "A"+[string]$accountid
                                    $ExcelWorkSheet.Range(“F"+$i) = [string]$customername

                                
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
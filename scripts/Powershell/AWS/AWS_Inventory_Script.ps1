

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




###################
### Main script ###
###################

    $customers = Import-Csv -Path "C:\Script\AllAccounts.csv"
    foreach ($customer in $customers)
    {
        $customername = $customer.'CustomerName'
        $accountid = $customer.'AccountID'

            ## Clear stored variables, except a few that are needed ###
            Get-Variable -Exclude accountid,defaultregion,customername,sCreds | Remove-Variable -EA 0

            ## Clear Credentials
            Clear-AWSCredential

            ## Reset Credentials
            Set-AWSCredentials -Credential $sCreds

            ## Assume role
                $Creds = (Use-STSRole -RoleArn "arn:aws:iam::$($accountid):role/OrganizationAccountAccessRole" -RoleSessionName "DJ").credentials
        
                if ($creds)
                {

                Set-AWSCredentials -Credential $Creds

            $date = Get-Date -format "dd.MM.yyyy"

            ### Creating the Word Object, set Word to visual and add document
            $word = New-Object -ComObject Word.Application
            $Word.Visible = $True
            $Document = $word.Documents.add("C:\Script\AWS_Template.dotx")
            $Section = $Document.Sections.Item(1)
            $Header = $Section.Headers.Item(1)
            $Header.Range.Text = "AWS Documentation for " + $customername + " taken on " + $date
            $Selection = $Word.Selection

            ## Add some text to start with
            $Selection.Style = 'Heading 1'
            $Selection.TypeText("AWS Documentation for " + $customername + " taken on " + $date)
            $Selection.TypeParagraph()

            ## Get Regions
            $regions = Get-ec2region

            ## Set counter to 0
            $r=0

            ## Loop for each
            Foreach ($region in $regions) 
            {

            $regionused = ""
            $vpccount = ""
            
            Set-DefaultAWSRegion -Region $region.regionname
            try{$vpccount = (get-ec2instance).length + (get-ec2volume).length}
            catch{"No Access to Region " + $region.RegionName}
            
            if ($vpccount -gt 0) 
            {

                $Selection.Style = 'Heading 1'
                $Selection.TypeText("Region - '" + $region.RegionName +"'")
                $Selection.TypeParagraph()
            


                    ## Get VPCs
                    $vpcs = get-ec2vpc

                    ########################### VPC ##############################

                    ## Write Heading
                    $Selection.Style = 'Heading 2'
                    $Selection.TypeText("VPC in Region '" + $region.RegionName +"'")
                    $Selection.TypeParagraph()
                    $Selection.Font.Size = 8

                    ## Add a table for VNets
                    $VNetTable = $Selection.Tables.add($Word.Selection.Range, $vpcs.Count + 1, 4,
                    [Microsoft.Office.Interop.Word.WdDefaultTableBehavior]::wdWord9TableBehavior,
                    [Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent
                    )

                    ## Write column headings
                    $VNetTable.Style = "AWS"
                    $VNetTable.Cell(1,1).Range.Text = "VPC Name"
                    $VNetTable.Cell(1,2).Range.Text = "VPC Id"
                    $VNetTable.Cell(1,3).Range.Text = "IP Block"

                        ## Set counter to 0
                        $i=0

                        ## Loop for each
                        Foreach ($vpc in $vpcs) {

                                $vpcname = ""
                                $tags = $vpc.Tags
	                            if(!([string]::IsNullOrEmpty($tags))){
	        	                    if($tags.Key -eq "Name"){$vpcname =  $tags | Where-Object { $_.Key -eq "Name" } | Select-Object -expand Value}   
	                            }

                            ## Write values to table
                            $VNetTable.cell(($i+2),1).range.Bold = 0
                            $VNetTable.cell(($i+2),1).range.text = [string]$vpcname
                            $VNetTable.cell(($i+2),2).range.Bold = 0
                            $VNetTable.cell(($i+2),2).range.text = [string]$vpc.vpcid
                            $VNetTable.cell(($i+2),3).range.Bold = 0
                            $VNetTable.cell(($i+2),3).range.text = [string]$vpc.CidrBlock

                        ## Increment counter
                        $i++
                        }

                    ## Add new section
                    $Word.Selection.Start= $Document.Content.End
                    $Selection.TypeParagraph()

                    ########################### VPC Details ##############################

                        ########################### Virtual Machines ##############################

                        ## Write Heading
                        $Selection.Style = 'Heading 2'
                        $Selection.TypeText("Virtual Machines in Region '" + $region.RegionName + "'")
                        $Selection.TypeParagraph()
                        $Selection.Font.Size = 8

                        ## Get VMs
                        $VMs = ""
                        $VMs = Get-EC2Instance | Select-Object Instances -ExpandProperty Instances
                
                        ## Add a table for VMs
                        $VMTable = $Selection.Tables.add($Word.Selection.Range, $VMs.Count + 1, 13,
                        [Microsoft.Office.Interop.Word.WdDefaultTableBehavior]::wdWord9TableBehavior,
                        [Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent
                        )

                        ## Write column headings
                        $VMTable.Style = "AWS"
                        $VMTable.Cell(1,1).Range.Text = "Name"
                        $VMTable.Cell(1,2).Range.Text = "InstanceID"
                        $VMTable.Cell(1,3).Range.Text = "Instance Type"
                        $VMTable.Cell(1,4).Range.Text = "VM State"
                        $VMTable.Cell(1,5).Range.Text = "VPC ID"
                        $VMTable.Cell(1,6).Range.Text = "Availability Zone"
                        $VMTable.Cell(1,7).Range.Text = "Last Launch Time"
                        $VMTable.Cell(1,8).Range.Text = "Public IP"
                        $VMTable.Cell(1,9).Range.Text = "Private IP"
                        $VMTable.Cell(1,10).Range.Text = "Platform"
                        $VMTable.Cell(1,11).Range.Text = "NIC ID"
                        $VMTable.Cell(1,12).Range.Text = "Subnet Name"
                        $VMTable.Cell(1,13).Range.Text = "Security Groups"


                            ## Set counter to 0
                            $i=0

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

                                    ## Write values to table
                                    $VMTable.cell(($i+2),1).range.Bold = 0
                                    $VMTable.cell(($i+2),1).range.text = [string]$ec2LogicalName
                                    $VMTable.cell(($i+2),2).range.Bold = 0
                                    $VMTable.cell(($i+2),2).range.text = [string]$VM.InstanceId
                                    $VMTable.cell(($i+2),3).range.Bold = 0
                                    $VMTable.cell(($i+2),3).range.text = [string]$VM.InstanceType.Value
                                    $VMTable.cell(($i+2),4).range.Bold = 0
                                    $VMTable.cell(($i+2),4).range.text = [string]$VM.State.Name.value
                                    $VMTable.cell(($i+2),5).range.Bold = 0
                                    $VMTable.cell(($i+2),5).range.text = [string]$vm.vpcid
                                    $VMTable.cell(($i+2),6).range.Bold = 0
                                    $VMTable.cell(($i+2),6).range.text = [string]$vm.placement.AvailabilityZone
                                    $VMTable.cell(($i+2),7).range.Bold = 0
                                    $VMTable.cell(($i+2),7).range.text = [string]$launchtime.Substring(0,10)
                                    $VMTable.cell(($i+2),8).range.Bold = 0
                                    $VMTable.cell(($i+2),8).range.text = [string]$VM.PublicIpAddress
                                    $VMTable.cell(($i+2),9).range.Bold = 0
                                    $VMTable.cell(($i+2),9).range.text = [string]$VM.PrivateIpAddress
                                    $VMTable.cell(($i+2),10).range.Bold = 0
                                    $VMTable.cell(($i+2),10).range.text = [string]$VM.Platform.Value
                                    $VMTable.cell(($i+2),11).range.Bold = 0
                                    $VMTable.cell(($i+2),11).range.text = [string]$vm.networkinterfaces.NetworkInterfaceId
                                    $VMTable.cell(($i+2),12).range.Bold = 0
                                    $VMTable.cell(($i+2),12).range.text = [string]$subnetname
                                    $VMTable.cell(($i+2),13).range.Bold = 0
                                    $VMTable.cell(($i+2),13).range.text = [string]$vm.networkinterfaces.groups.groupname
                          
                                
                            ## Increment counter
                            $i++
                            }       

                        ## Create new section
                        $Word.Selection.Start= $Document.Content.End
                        $Selection.TypeParagraph()


                        ########################### Disks ##############################

                        ## Write Heading
                        $Selection.Style = 'Heading 2'
                        $Selection.TypeText("Disks in Region '" + $region.RegionName + "'")
                        $Selection.TypeParagraph()
                        $Selection.Font.Size = 8

                        ## Get Disks
                        $disks = get-ec2volume

                        ## Add a table for Storage
                        $DskTable = $Selection.Tables.add($Word.Selection.Range, $disks.Count + 1, 8,
                        [Microsoft.Office.Interop.Word.WdDefaultTableBehavior]::wdWord9TableBehavior,
                        [Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent
                        )

                        ## Write column headings
                        $DskTable.Style = "AWS"
                        $DskTable.Cell(1,1).Range.Text = "Device Name"
                        $DskTable.Cell(1,2).Range.Text = "Attached VM"
                        $DskTable.Cell(1,3).Range.Text = "Size"
                        $DskTable.Cell(1,4).Range.Text = "Iops"
                        $DskTable.Cell(1,5).Range.Text = "Volume Type"
                        $DskTable.Cell(1,6).Range.Text = "Encrypted"
                        $DskTable.Cell(1,7).Range.Text = "VolumeID"
                        $DskTable.Cell(1,8).Range.Text = "AZ"

                            ## Set counter to 0
                            $i=0

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
                                $DskTable.cell(($i+2),1).range.Bold = 0
                                $DskTable.cell(($i+2),1).range.text = [string]$disk.Attachment.Device
                                $DskTable.cell(($i+2),2).range.Bold = 0
                                $DskTable.cell(($i+2),2).range.text = [string]$ec2LogicalName
                                $DskTable.cell(($i+2),3).range.Bold = 0
                                $DskTable.cell(($i+2),3).range.text = [string]$disk.Size
                                $DskTable.cell(($i+2),4).range.Bold = 0
                                $DskTable.cell(($i+2),4).range.text = [string]$disk.Iops
                                $DskTable.cell(($i+2),5).range.Bold = 0
                                $DskTable.cell(($i+2),5).range.text = [string]$disk.VolumeType
                                $DskTable.cell(($i+2),6).range.Bold = 0
                                $DskTable.cell(($i+2),6).range.text = [string]$disk.Encrypted
                                $DskTable.cell(($i+2),7).range.Bold = 0
                                $DskTable.cell(($i+2),7).range.text = [string]$disk.Volumeid
                                $DskTable.cell(($i+2),8).range.Bold = 0
                                $DskTable.cell(($i+2),8).range.text = [string]$disk.AvailabilityZone

                            ## Increment counter
                            $i++
                            }

                        ## Add new section
                        $Word.Selection.Start= $Document.Content.End
                        $Selection.TypeParagraph()


                        ########################### S3 Buckets ##############################

                        ## Write Heading
                        $Selection.Style = 'Heading 2'
                        $Selection.TypeText("S3 Buckets in Region '" + $region.RegionName + "'")
                        $Selection.TypeParagraph()
                        $Selection.Font.Size = 8

                        ## Get Virtual Networks

                        $s3s = get-s3bucket -region us-east-1 | Where-Object { $_.BucketName -notlike "aws-quick-setup-config-recording*" }

                        ## Add a table for VNets
                        $VNetTable = $Selection.Tables.add($Word.Selection.Range, $s3s.Count + 1, 4,
                        [Microsoft.Office.Interop.Word.WdDefaultTableBehavior]::wdWord9TableBehavior,
                        [Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent
                        )

                        ## Write column headings
                        $VNetTable.Style = "AWS"
                        $VNetTable.Cell(1,1).Range.Text = "S3 Bucket Name"
                        $VNetTable.Cell(1,2).Range.Text = "Current Size"
                        $VNetTable.Cell(1,3).Range.Text = "Public Access"
                        $VNetTable.Cell(1,4).Range.Text = "Region"

                            ## Set counter to 0
                            $i=0

                            ## Loop for each
                            Foreach ($s3 in $s3s) {

                            $s3sizegb = ""
                            $s3sizekb = ""
                            $s3finalsize = ""


                            ## Get S3 Public Access
                            try {
                                $publicall = Get-S3PublicAccessBlock -BucketName $s3.BucketName -region $region.RegionName
                                $public = $publicall.BlockPublicAcls
                                if ($public -eq "True") {$public = "Public Access Blocked"} {$public = "Public Access Open"}}
                            catch
                                {}

                            ## Get Size of the S3 Bucket
                            foreach ($s3sizekb in (Get-S3Object -BucketName $s3.BucketName -region $region.RegionName | Select-Object Size)) {$s3sizegb = $s3sizekb.Size/1024/1024}
                            $s3finalsize = [math]::Round($s3sizegb,2)
                        
                                    ## Write values to table
                                    $VNetTable.cell(($i+2),1).range.Bold = 0
                                    $VNetTable.cell(($i+2),1).range.text = [string]$s3.BucketName
                                    $VNetTable.cell(($i+2),2).range.Bold = 0
                                    $VNetTable.cell(($i+2),2).range.text = [string]$s3finalsize + " GB"
                                    $VNetTable.cell(($i+2),3).range.Bold = 0
                                    $VNetTable.cell(($i+2),3).range.text = [string]$public
                                    $VNetTable.cell(($i+2),4).range.Bold = 0
                                    $VNetTable.cell(($i+2),4).range.text = [string]$region.RegionName

                            ## Increment counter
                            $i++
                            }

                        ## Add new section
                        $Word.Selection.Start= $Document.Content.End
                        $Selection.TypeParagraph()


                        ########################### Virtual Networks ##############################

                        ## Write Heading
                        $Selection.Style = 'Heading 2'
                        $Selection.TypeText("Subnets in Region '" + $region.RegionName + "'")
                        $Selection.TypeParagraph()
                        $Selection.Font.Size = 8

                        ## Get Virtual Networks
                        $subnets = get-ec2subnet

                        ## Add a table for VNets
                        $VNetTable = $Selection.Tables.add($Word.Selection.Range, $subnets.Count + 1, 4,
                        [Microsoft.Office.Interop.Word.WdDefaultTableBehavior]::wdWord9TableBehavior,
                        [Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent
                        )

                        ## Write column headings
                        $VNetTable.Style = "AWS"
                        $VNetTable.Cell(1,1).Range.Text = "Subnet Name"
                        $VNetTable.Cell(1,2).Range.Text = "SubnetID"
                        $VNetTable.Cell(1,3).Range.Text = "AZ"
                        $VNetTable.Cell(1,4).Range.Text = "IP Range"

                            ## Set counter to 0
                            $i=0

                            ## Loop for each
                            Foreach ($subnet in $subnets) {

                                $subnetname = ""
                                $tags = $subnet.Tags
	                            if(!([string]::IsNullOrEmpty($tags)))
                                    {
	        	                        if($tags.Key -eq "Name"){$subnetname =  $tags | Where-Object { $_.Key -eq "Name" } | Select-Object -expand Value}   
	                                }

                                ## Write values to table
                                $VNetTable.cell(($i+2),1).range.Bold = 0
                                $VNetTable.cell(($i+2),1).range.text = [string]$subnetname
                                $VNetTable.cell(($i+2),2).range.Bold = 0
                                $VNetTable.cell(($i+2),2).range.text = [string]$subnet.SubnetId
                                $VNetTable.cell(($i+2),3).range.Bold = 0
                                $VNetTable.cell(($i+2),3).range.text = [string]$subnet.AvailabilityZone
                                $VNetTable.cell(($i+2),4).range.Bold = 0
                                $VNetTable.cell(($i+2),4).range.text = [string]$subnet.CidrBlock

                            ## Increment counter
                            $i++
                            }

                        ## Add new section
                        $Word.Selection.Start= $Document.Content.End
                        $Selection.TypeParagraph()

                        ########################### Security Groups ##############################

                        ## Write Heading
                        $Selection.Style = 'Heading 2'
                        $Selection.TypeText("Security Groups in Region '" + $region.RegionName + "'")
                        $Selection.TypeParagraph()
                        $Selection.Font.Size = 8

                        ## Get Virtual Networks
                        $secgroups = Get-EC2SecurityGroup -Region $region.RegionName

                        ## Add a table for VNets
                        $SecGroupTable = $Selection.Tables.add($Word.Selection.Range, $secgroups.Count + 1, 4,
                        [Microsoft.Office.Interop.Word.WdDefaultTableBehavior]::wdWord9TableBehavior,
                        [Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent
                        )

                        ## Write column headings
                        $SecGroupTable.Style = "AWS"
                        $SecGroupTable.Cell(1,1).Range.Text = "Group Name"
                        $SecGroupTable.Cell(1,2).Range.Text = "Group ID"
                        $SecGroupTable.Cell(1,3).Range.Text = "Group Details"
                        $SecGroupTable.Cell(1,4).Range.Text = "VPC"

                            ## Set counter to 0
                            $s=0

                            ## Loop for each
                            Foreach ($secgroup in $secgroups) {

                                ## Write values to table
                                $SecGroupTable.cell(($s+2),1).range.Bold = 0
                                $SecGroupTable.cell(($s+2),1).range.text = [string]$secgroup.GroupName
                                $SecGroupTable.cell(($s+2),2).range.Bold = 0
                                $SecGroupTable.cell(($s+2),2).range.text = [string]$secgroup.GroupID
                                $SecGroupTable.cell(($s+2),3).range.Bold = 0
                                $SecGroupTable.cell(($s+2),3).range.text = [string]$secgroup.Description
                                $SecGroupTable.cell(($s+2),4).range.Bold = 0
                                $SecGroupTable.cell(($s+2),4).range.text = [string]$secgroup.VpcId

                            ## Increment counter
                            $s++
                            }

                        ## Add new section
                        $Word.Selection.Start= $Document.Content.End
                        $Selection.TypeParagraph()

                                        ########################### Security Groups Sub Loop ##############################

                                        ## Set counter to 0
                                        $s=0

                                                ## Loop for each
                                                Foreach ($secgroup in $secgroups) {
                                                            
                                                $sg = get-ec2securitygroup -GroupId $secgroup.GroupID
                                                $rules = $sg.ippermissions

                                                ## Write Heading
                                                $Selection.Style = 'Heading 2'
                                                $Selection.TypeText("Security Groups Details for Rule '" + $secgroup.GroupName + "'")
                                                $Selection.TypeParagraph()
                                                $Selection.Font.Size = 8

                                                ## Add a table for VNets
                                                $RuleTable = $Selection.Tables.add($Word.Selection.Range, $rules.Count + 1, 4,
                                                [Microsoft.Office.Interop.Word.WdDefaultTableBehavior]::wdWord9TableBehavior,
                                                [Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent
                                                )

                                                ## Write column headings
                                                $RuleTable.Style = "AWS"
                                                $RuleTable.Cell(1,1).Range.Text = "Protocol"
                                                $RuleTable.Cell(1,2).Range.Text = "From Port"
                                                $RuleTable.Cell(1,3).Range.Text = "To Port"
                                                $RuleTable.Cell(1,4).Range.Text = "IP Ranges"

                                                    ## Set counter to 0
                                                    $r=0

                                                    ## Loop for each
                                                    Foreach ($rule in $rules) {

                                                        ## Write values to table
                                                        $RuleTable.cell(($r+2),1).range.Bold = 0
                                                        $RuleTable.cell(($r+2),1).range.text = [string]$rule.IpProtocol
                                                        $RuleTable.cell(($r+2),2).range.Bold = 0
                                                        $RuleTable.cell(($r+2),2).range.text = [string]$rule.FromPort
                                                        $RuleTable.cell(($r+2),3).range.Bold = 0
                                                        $RuleTable.cell(($r+2),3).range.text = [string]$rule.ToPort
                                                        $RuleTable.cell(($r+2),4).range.Bold = 0
                                                        $RuleTable.cell(($r+2),4).range.text = [string]$rule.IPv4ranges.CidrIP
                                            
                                                    ## Increment counter
                                                    $r++
                                                    }

                                                ## Add new section
                                                $Word.Selection.Start= $Document.Content.End
                                                $Selection.TypeParagraph()

                                        ## Increment counter
                                        $s++
                                        }


                }                   
             }

                        
                $file = "C:\Script\Reports\AWS-Documentation-" + $customername.ToUpper() + ".docx"
                [ref]$SaveFormat = “microsoft.office.interop.word.WdSaveFormat” -as [type]
                $document.saveas([ref] $file, [ref]$SaveFormat::wdFormatDocumentDefault)
                $document.Close()
                $word.Quit()

        } else {"No Access to account"}

    }




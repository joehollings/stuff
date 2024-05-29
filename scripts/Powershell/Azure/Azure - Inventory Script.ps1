# Connect to Azure and get all VMs in a resource group
#Add-AzAccount -SubscriptionId 50ca1b14-e3b0-4ecf-be34-96f334cd7a75

# Set Resource Group
$rsg = "10027-rsg-prod"

# Creating the Word Object, set Word to visual and add document
$Word = New-Object -ComObject Word.Application
$Word.Visible = $True
$Document = $Word.Documents.Add()
$Document.PageSetup.Orientation = 1
$Selection = $Word.Selection

## Add some text to start with
$Selection.Style = 'Heading 1'
$Selection.TypeText("Azure Documentation")
$Selection.TypeParagraph()

########################### Virtual Machines ##############################

## Write Heading
$Selection.Style = 'Heading 2'
$Selection.TypeText("Virtual Machines in " + $rsg)
$Selection.TypeParagraph()
$Selection.Font.Size = 9

## Get VMs
$VMs = Get-AzVM -ResourceGroupName $rsg

## Get Backup Vault
Get-AzRecoveryServicesVault -ResourceGroupName $rsg | Set-AzRecoveryServicesVaultContext

## Add a table for VMs
$VMTable = $Selection.Tables.add($Word.Selection.Range, $VMs.Count + 1, 7,
[Microsoft.Office.Interop.Word.WdDefaultTableBehavior]::wdWord9TableBehavior,
[Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent
)

## Write column headings
$VMTable.Style = "Grid Table 4 - Accent 3"
$VMTable.Cell(1,1).Range.Text = "Name"
$VMTable.Cell(1,2).Range.Text = "VM Size"
$VMTable.Cell(1,3).Range.Text = "Location"
$VMTable.Cell(1,4).Range.Text = "Network Interface"
$VMTable.Cell(1,5).Range.Text = "Availability Set"
$VMTable.Cell(1,6).Range.Text = "Proximity Placement Group"
$VMTable.Cell(1,7).Range.Text = "Backup Policy"


    ## Set counter to 0
    $i=0#

    ## Loop for each
    Foreach ($VM in $VMs) {

            ## Get short NIC name
            $VMName = $VM.NetworkProfile.NetworkInterfaces.ID
            $Parts = $VMName.Split("/")
            $NIC = $Parts[8]

            ## Get short proximity placement group name
            $ppgpart = ""
            $ppgfull = $VM.ProximityPlacementGroup
            $ppgpart = $ppgfull.Id.Split("/")
            $ppg = $ppgpart[8]

            ## Get short availability set name
            $avspart = ""
            $avsfull = $VM.AvailabilitySetReference
            $avspart = $avsfull.Id.Split("/")
            $avs = $avspart[8]

            ## Get backup policy for the VM
            $vmbackpol = ""
            $vmbackcontainer = Get-AzRecoveryServicesBackupContainer -ContainerType "AzureVM" -FriendlyName $VM.Name
            $vmbackpol = Get-AzRecoveryServicesBackupItem -Container $vmbackcontainer -WorkloadType "AzureVM"

            Get-AzRecoveryServicesBackupContainer -ContainerType 

            ## Write values to table
            $VMTable.cell(($i+2),1).range.Bold = 0
            $VMTable.cell(($i+2),1).range.text = $VM.Name.ToLower()
            $VMTable.cell(($i+2),2).range.Bold = 0
            $VMTable.cell(($i+2),2).range.text = $VM.HardwareProfile.VmSize.ToLower()
            $VMTable.cell(($i+2),3).range.Bold = 0
            $VMTable.cell(($i+2),3).range.text = $VM.Location
            $VMTable.cell(($i+2),4).range.Bold = 0
            $VMTable.cell(($i+2),4).range.text = $NIC.ToLower()
            $VMTable.cell(($i+2),5).range.Bold = 0
            $VMTable.cell(($i+2),5).range.text = $avs.ToLower()
            $VMTable.cell(($i+2),6).range.Bold = 0
            $VMTable.cell(($i+2),6).range.text = $ppg.ToLower()
            $VMTable.cell(($i+2),7).range.Bold = 0
            $VMTable.cell(($i+2),7).range.text = $vmbackpol.ProtectionPolicyName

    ## Increment counter
    $i++
    }       

## Create new section
$Word.Selection.Start= $Document.Content.End
$Selection.TypeParagraph()

########################### NICS ##############################

## Write Heading
$Selection.Style = 'Heading 2'
$Selection.TypeText("Network Interfaces in " + $rsg)
$Selection.TypeParagraph()
$Selection.Font.Size = 9

## Get NICs
$nics = Get-AzNetworkInterface -ResourceGroupName $rsg

## Add a table for Storage
$NicTable = $Selection.Tables.add($Word.Selection.Range, $nics.Count + 1, 6,
[Microsoft.Office.Interop.Word.WdDefaultTableBehavior]::wdWord9TableBehavior,
[Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent
)

## Write column headings
$NicTable.Style = "Grid Table 4 - Accent 3"
$NicTable.Cell(1,1).Range.Text = "NIC Name"
$NicTable.Cell(1,2).Range.Text = "Attached VM"
$NicTable.Cell(1,3).Range.Text = "Location"
$NicTable.Cell(1,4).Range.Text = "Subnet"
$NicTable.Cell(1,5).Range.Text = "IP Address"
$NicTable.Cell(1,6).Range.Text = "Accelerated"

    ## Set counter to 0
    $i=0

    ## Loop for each
    Foreach ($nic in $nics) {

        ## Get VM associated to NIC
        $nicvmpart = ""
        $nicvmfull = $nic.VirtualMachine.Id
        $nicvmpart = $nicvmfull.Split("/")
        $nicvm = $nicvmpart[8]

        ## Get NIC subnet short name
        $nicsubpart = ""
        $nicsubfull = $nic.IpConfigurations.Subnet.Id
        $nicsubpart = $nicsubfull.Split("/")
        $nicsub = $nicsubpart[8]

        ## Write values to table
        $NicTable.cell(($i+2),1).range.Bold = 0
        $NicTable.cell(($i+2),1).range.text = $nic.Name
        $NicTable.cell(($i+2),2).range.Bold = 0
        $NicTable.cell(($i+2),2).range.text = $nicvm
        $NicTable.cell(($i+2),3).range.Bold = 0
        $NicTable.cell(($i+2),3).range.text = $nic.Location
        $NicTable.cell(($i+2),4).range.Bold = 0
        $NicTable.cell(($i+2),4).range.text = $nicsub
        $NicTable.cell(($i+2),5).range.Bold = 0
        $NicTable.cell(($i+2),5).range.text = $nic.IpConfigurations.PrivateIpAddress
        $NicTable.cell(($i+2),6).range.Bold = 0
        $NicTable.cell(($i+2),6).range.text = [String]$nic.EnableAcceleratedNetworking

    ## Increment counter
    $i++
    }

## Create new section
$Word.Selection.Start= $Document.Content.End
$Selection.TypeParagraph()

########################### Virtual Networks ##############################

## Write Heading
$Selection.Style = 'Heading 2'
$Selection.TypeText("Virtual Networks in " + $rsg)
$Selection.TypeParagraph()
$Selection.Font.Size = 9

## Get Virtual Networks
$vnets = Get-AzVirtualNetwork -ResourceGroupName $rsg

## Add a table for VNets
$VNetTable = $Selection.Tables.add($Word.Selection.Range, $vnets.Count + 1, 5,
[Microsoft.Office.Interop.Word.WdDefaultTableBehavior]::wdWord9TableBehavior,
[Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent
)

## Write column headings
$VNetTable.Style = "Grid Table 4 - Accent 3"
$VNetTable.Cell(1,1).Range.Text = "Name"
$VNetTable.Cell(1,2).Range.Text = "Location"
$VNetTable.Cell(1,3).Range.Text = "Address Space"
$VNetTable.Cell(1,4).Range.Text = "Subnet Names"
$VNetTable.Cell(1,5).Range.Text = "Subnet Ranges"


    ## Set counter to 0
    $i=0

    ## Loop for each
    Foreach ($vnet in $vnets) {

        ## Write values to table
        $VNetTable.cell(($i+2),1).range.Bold = 0
        $VNetTable.cell(($i+2),1).range.text = $vnet.Name.ToLower()
        $VNetTable.cell(($i+2),2).range.Bold = 0
        $VNetTable.cell(($i+2),2).range.text = $vnet.Location.ToLower()
        $VNetTable.cell(($i+2),3).range.Bold = 0
        $VNetTable.cell(($i+2),3).range.text = [String]$vnet.AddressSpace.AddressPrefixes
        $VNetTable.cell(($i+2),4).range.Bold = 0
        $VNetTable.cell(($i+2),4).range.text = ([String]$vnet.Subnets.Name.ToLower()).Replace(" ","`r")
        $VNetTable.cell(($i+2),5).range.Bold = 0
        $VNetTable.cell(($i+2),5).range.text = ([String]$vnet.Subnets.AddressPrefix).Replace(" ","`r")

    ## Increment counter
    $i++
    }

## Add new section
$Word.Selection.Start= $Document.Content.End
$Selection.TypeParagraph()

########################### Storage ##############################

## Write Heading
$Selection.Style = 'Heading 2'
$Selection.TypeText("Storage in " + $rsg)
$Selection.TypeText(" ")
$Selection.TypeParagraph()
$Selection.Font.Size = 9

## Get Storage Account
$stores = Get-AzStorageAccount -ResourceGroupName $rsg

    ## Set counter to 0
    $s=0
    
    ## Loop for each Storage Account
    Foreach ($store in $stores) {

        ## Get list of Shared
        $storecontext = $store.context
        $shares = Get-AzStorageShare -Context $storecontext | where-object {$_.IsSnapshot -eq $false}

        ## Add a table for Storage
        $Selection.Style = 'Heading 2'
        $Selection.TypeText("Storage Account - " + $store.StorageAccountName)
        $Selection.TypeParagraph()
        $Selection.Font.Size = 9
        $StTable = $Selection.Tables.add($Word.Selection.Range, $shares.Count + 1, 8,
        [Microsoft.Office.Interop.Word.WdDefaultTableBehavior]::wdWord9TableBehavior,
        [Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent
        )

        ## Write column headings
        $StTable.Style = "Grid Table 4 - Accent 3"
        $StTable.Cell(1,1).Range.Text = "Account Name"
        $StTable.Cell(1,2).Range.Text = "Share Name"
        $StTable.Cell(1,3).Range.Text = "Location"
        $StTable.Cell(1,4).Range.Text = "Quota (in GB)"
        $StTable.Cell(1,5).Range.Text = "Protocol"
        $StTable.Cell(1,6).Range.Text = "Tier"
        $StTable.Cell(1,7).Range.Text = "IOPS"
        $StTable.Cell(1,8).Range.Text = "URI"

        ## Set Counter to 0
        $i=0

        ## Loop for each Share
        Foreach ($share in $shares) {

            ## Write values to table
            $StTable.cell(($i+2),1).range.Bold = 0
            $StTable.cell(($i+2),1).range.text = $store.StorageAccountName
            $StTable.cell(($i+2),2).range.Bold = 0
            $StTable.cell(($i+2),2).range.text = $share.Name
            $StTable.cell(($i+2),3).range.Bold = 0
            $StTable.cell(($i+2),3).range.text = $store.Location
            $StTable.cell(($i+2),4).range.Bold = 0
            $StTable.cell(($i+2),4).range.text = [String]$share.ShareProperties.QuotaInGB
            $StTable.cell(($i+2),5).range.Bold = 0
            $StTable.cell(($i+2),5).range.text = ([String]$share.ShareProperties.Protocols).ToUpper()
            $StTable.cell(($i+2),6).range.Bold = 0
            $StTable.cell(($i+2),6).range.text = $share.ShareProperties.AccessTier
            $StTable.cell(($i+2),7).range.Bold = 0
            $StTable.cell(($i+2),7).range.text = [String]$share.ShareProperties.ProvisionedIops
            $StTable.cell(($i+2),8).range.Bold = 0
            $StTable.cell(($i+2),8).range.text = [String]$share.ShareClient.URI

        ## Increment Counter
        $i++
        }

        ## Add new section
        $Word.Selection.Start= $Document.Content.End
        $Selection.TypeParagraph()

    ## Increment Counter
    $s++
    }

## Add new section
$Word.Selection.Start= $Document.Content.End
$Selection.TypeParagraph()

########################### Disks ##############################

## Write Heading
$Selection.Style = 'Heading 2'
$Selection.TypeText("Disks in " + $rsg)
$Selection.TypeParagraph()
$Selection.Font.Size = 9

## Get Disks
$disks = Get-AzDisk -ResourceGroupName $rsg

## Add a table for Storage
$DskTable = $Selection.Tables.add($Word.Selection.Range, $disks.Count + 1, 7,
[Microsoft.Office.Interop.Word.WdDefaultTableBehavior]::wdWord9TableBehavior,
[Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent
)

## Write column headings
$DskTable.Style = "Grid Table 4 - Accent 3"
$DskTable.Cell(1,1).Range.Text = "Disk Name"
$DskTable.Cell(1,2).Range.Text = "Attached VM"
$DskTable.Cell(1,3).Range.Text = "Location"
$DskTable.Cell(1,4).Range.Text = "Size (in GB)"
$DskTable.Cell(1,5).Range.Text = "Disk Tier"
$DskTable.Cell(1,6).Range.Text = "Disk Type"
$DskTable.Cell(1,7).Range.Text = "IOPS"

    ## Set counter to 0
    $i=0

    ## For each loop
    Foreach ($disk in $disks) {

        ## Get disk owner name
        $diskpart = ""
        $diskfull = $disk.ManagedBy
        $diskpart = $diskfull.Split("/")
        $diskowner = $diskpart[8]

        ## Write values to table
        $DskTable.cell(($i+2),1).range.Bold = 0
        $DskTable.cell(($i+2),1).range.text = $disk.Name
        $DskTable.cell(($i+2),2).range.Bold = 0
        $DskTable.cell(($i+2),2).range.text = $diskowner
        $DskTable.cell(($i+2),3).range.Bold = 0
        $DskTable.cell(($i+2),3).range.text = $disk.Location
        $DskTable.cell(($i+2),4).range.Bold = 0
        $DskTable.cell(($i+2),4).range.text = [String]$disk.DiskSizeGB
        $DskTable.cell(($i+2),5).range.Bold = 0
        $DskTable.cell(($i+2),5).range.text = $disk.Tier
        $DskTable.cell(($i+2),6).range.Bold = 0
        $DskTable.cell(($i+2),6).range.text = $disk.Sku.Name
        $DskTable.cell(($i+2),7).range.Bold = 0
        $DskTable.cell(($i+2),7).range.text = [String]$disk.DiskIOPSReadWrite

    ## Increment counter
    $i++
    }

## Add new section
$Word.Selection.Start= $Document.Content.End
$Selection.TypeParagraph()

########################### Availability Sets ##############################

## Write Heading
$Selection.Style = 'Heading 2'
$Selection.TypeText("Availability Sets in " + $rsg)
$Selection.TypeParagraph()
$Selection.Font.Size = 9

## Get Availability Sets
$avails = Get-AzAvailabilitySet -ResourceGroupName $rsg

## Add a table for Storage
$AvailTable = $Selection.Tables.add($Word.Selection.Range, $avails.Count + 1, 6,
[Microsoft.Office.Interop.Word.WdDefaultTableBehavior]::wdWord9TableBehavior,
[Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent
)

## Write column headings
$AvailTable.Style = "Grid Table 4 - Accent 3"
$AvailTable.Cell(1,1).Range.Text = "Availability Set Name"
$AvailTable.Cell(1,2).Range.Text = "Location"
$AvailTable.Cell(1,3).Range.Text = "Platform Fault Domain Count"
$AvailTable.Cell(1,4).Range.Text = "Platform Update Domain Count"
$AvailTable.Cell(1,5).Range.Text = "Proximity Placement Group"
$AvailTable.Cell(1,6).Range.Text = "SKU"

    ## Set counter to 0
    $i=0

    ## For each loop
    Foreach ($avail in $avails) {

        ## Write values to table
        $AvailTable.cell(($i+2),1).range.Bold = 0
        $AvailTable.cell(($i+2),1).range.text = $avail.Name
        $AvailTable.cell(($i+2),2).range.Bold = 0
        $AvailTable.cell(($i+2),2).range.text = $avail.Location
        $AvailTable.cell(($i+2),3).range.Bold = 0
        $AvailTable.cell(($i+2),3).range.text = [String]$avail.PlatformFaultDomainCount
        $AvailTable.cell(($i+2),4).range.Bold = 0
        $AvailTable.cell(($i+2),4).range.text = [String]$avail.PlatformUpdateDomainCount
        $AvailTable.cell(($i+2),5).range.Bold = 0
        $AvailTable.cell(($i+2),5).range.text = $avail.ProximityPlacementGroup
        $AvailTable.cell(($i+2),6).range.Bold = 0
        $AvailTable.cell(($i+2),6).range.text = $avail.Sku

    ## Increment counter
    $i++
    }

## Create new section
$Word.Selection.Start= $Document.Content.End
$Selection.TypeParagraph()

########################### Proximity Placement Groups ##############################

## Write Heading
$Selection.Style = 'Heading 2'
$Selection.TypeText("Proximity Placement Groups in " + $rsg)
$Selection.TypeParagraph()
$Selection.Font.Size = 9

## Get Proximity Placement Groups
$PPGS = Get-AzProximityPlacementGroup -ResourceGroupName $rsg

## Add a table for Storage
$PPGTable = $Selection.Tables.add($Word.Selection.Range, $PPGS.Count + 1, 3,
[Microsoft.Office.Interop.Word.WdDefaultTableBehavior]::wdWord9TableBehavior,
[Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent
)

## Write column headings
$PPGTable.Style = "Grid Table 4 - Accent 3"
$PPGTable.Cell(1,1).Range.Text = "Proximity Placement Group Name"
$PPGTable.Cell(1,2).Range.Text = "Location"
$PPGTable.Cell(1,3).Range.Text = "Type"

    ## Set counter to 0
    $i=0
    Foreach ($PPG in $PPGs) {

        ## Write values to table
        $PPGTable.cell(($i+2),1).range.Bold = 0
        $PPGTable.cell(($i+2),1).range.text = $PPG.Name
        $PPGTable.cell(($i+2),2).range.Bold = 0
        $PPGTable.cell(($i+2),2).range.text = $PPG.Location
        $PPGTable.cell(($i+2),3).range.Bold = 0
        $PPGTable.cell(($i+2),3).range.text = $PPG.ProximityPlacementGroupType

    $i++
    }

## Create new section
$Word.Selection.Start= $Document.Content.End
$Selection.TypeParagraph()

########################### Backups ##############################

## Write Heading
$Selection.Style = 'Heading 2'
$Selection.TypeText("Backup Vault and Policies in " + $rsg)
$Selection.TypeParagraph()
$Selection.Font.Size = 9

## Get Backup Vault
$backv = Get-AzRecoveryServicesVault -ResourceGroupName $rsg

## Get Backup Protection Policy
$backs = Get-AzRecoveryServicesBackupProtectionPolicy -VaultId $backv.ID

## Add a table for Backups Policies
$backvTable = $Selection.Tables.add($Word.Selection.Range, $backv.Count + 1, 2,
[Microsoft.Office.Interop.Word.WdDefaultTableBehavior]::wdWord9TableBehavior,
[Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent
)

## Write column headings
$backvTable.Style = "Grid Table 4 - Accent 3"
$backvTable.Cell(1,1).Range.Text = "Backup Vault Name"
$backvTable.Cell(1,2).Range.Text = "Location"

    ## Set counter to 0
    $i=0

    ## Write values to table
    $backvTable.cell(($i+2),1).range.Bold = 0
    $backvTable.cell(($i+2),1).range.text = $backv.Name
    $backvTable.cell(($i+2),2).range.Bold = 0
    $backvTable.cell(($i+2),2).range.text = $backv.Location

## Add new section
$Word.Selection.Start= $Document.Content.End
$Selection.TypeParagraph()

## Add a table for Backups Policies
$backTable = $Selection.Tables.add($Word.Selection.Range, $backS.Count + 1, 9,
[Microsoft.Office.Interop.Word.WdDefaultTableBehavior]::wdWord9TableBehavior,
[Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent
)

## Write column headings
$backTable.Style = "Grid Table 4 - Accent 3"
$backTable.Cell(1,1).Range.Text = "Policy Name"
$backTable.Cell(1,2).Range.Text = "Workload Type"
$backTable.Cell(1,3).Range.Text = "Frequency"
$backTable.Cell(1,4).Range.Text = "Day"
$backTable.Cell(1,5).Range.Text = "Time"
$backTable.Cell(1,6).Range.Text = "Daily Snapshots to Retain"
$backTable.Cell(1,7).Range.Text = "Retain Daily for (Days)"
$backTable.Cell(1,8).Range.Text = "Retain Weekly Point on (Day)"
$backTable.Cell(1,9).Range.Text = "Retain Weekly for (Weeks)"

    ## Set counter to 0
    $i=0
    Foreach ($back in $backs) {

        ## Get Backup Policy Schedule
        $backsch = $back.SchedulePolicy

        ## Get Backup Policy Retention
        $backret = $back.RetentionPolicy

        ## Get Backup Time from DateTime
        $backtimepart = ""
        $backtimefull = [String]$backsch.ScheduleRunTimes 
        $backtimepart = $backtimefull.Split(" ")
        $backtime = $backtimepart[1]

        ## Write values to table
        $backTable.cell(($i+2),1).range.Bold = 0
        $backTable.cell(($i+2),1).range.text = $back.Name
        $backTable.cell(($i+2),2).range.Bold = 0
        $backTable.cell(($i+2),2).range.text = [String]$back.WorkloadType
        $backTable.cell(($i+2),3).range.Bold = 0
        $backTable.cell(($i+2),3).range.text = [String]$backsch.ScheduleRunFrequency
        $backTable.cell(($i+2),4).range.Bold = 0
        $backTable.cell(($i+2),4).range.text = ([String]$backsch.ScheduleRunDays).Replace("{","")
        $backTable.cell(($i+2),5).range.Bold = 0
        $backTable.cell(($i+2),5).range.text = $backtime
        $backTable.cell(($i+2),6).range.Bold = 0
        $backTable.cell(($i+2),6).range.text = [String]$back.SnapshotRetentionInDays
        $backTable.cell(($i+2),7).range.Bold = 0
        $backTable.cell(($i+2),7).range.text = [String]$backret.DailySchedule.DurationCountInDays
        $backTable.cell(($i+2),8).range.Bold = 0
        $backTable.cell(($i+2),8).range.text = [String]$backret.WeeklySchedule.DaysOfTheWeek
        $backTable.cell(($i+2),9).range.Bold = 0
        $backTable.cell(($i+2),9).range.text = [String]$backret.WeeklySchedule.DurationCountInWeeks

    ## Increment counter
    $i++
    }

## Create new section
$Word.Selection.Start= $Document.Content.End
$Selection.TypeParagraph()

########################### CLEAN UP ##############################

# Save the document
$Report = 'C:\Temp\Azure_inventory_' + $rsg + '_' + (Get-Date -Format ddMMyy) + '.doc'
$Document.SaveAs([ref]$Report,[ref]$SaveFormat::wdFormatDocument)
#$word.Quit()

# Free up memory
$null = [System.Runtime.InteropServices.Marshal]::ReleaseComObject([System.__ComObject]$word)
[gc]::Collect()
[gc]::WaitForPendingFinalizers()
Remove-Variable word

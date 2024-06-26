#Connect-AzAccount
# Set variables
$resourceGroup = "RG-OWSCS-HUB"
$vmName = "azrcswdc01"
$newAvailSetName = "owscs-avail-ad-prod"

# Get the details of the VM to be moved to the Availability Set
$originalVM = Get-AzVM `
   -ResourceGroupName $resourceGroup `
   -Name $vmName

# Create new availability set if it does not exist
$availSet = Get-AzAvailabilitySet `
   -ResourceGroupName $resourceGroup `
   -Name $newAvailSetName `
   -ErrorAction Ignore
if (-Not $availSet) {
$availSet = New-AzAvailabilitySet `
   -Location $originalVM.Location `n
   -Name $newAvailSetName `y
   -ResourceGroupName $resourceGroup `
   -PlatformFaultDomainCount 2 `
   -PlatformUpdateDomainCount 2 `
   -Sku Aligned
}

# Remove the original VM
Remove-AzVM -ResourceGroupName $resourceGroup -Name $vmName    

# Create the basic configuration for the replacement VM. 
$newVM = New-AzVMConfig `
   -VMName $originalVM.Name `
   -VMSize $originalVM.HardwareProfile.VmSize `
   -AvailabilitySetId $availSet.Id

# For a Linux VM, change the last parameter from -Windows to -Linux 
Set-AzVMOSDisk `
   -VM $newVM -CreateOption Attach `
   -ManagedDiskId $originalVM.StorageProfile.OsDisk.ManagedDisk.Id `
   -Name $originalVM.StorageProfile.OsDisk.Name `
   -Windows

# Add Data Disks
foreach ($disk in $originalVM.StorageProfile.DataDisks) { 
Add-AzVMDataDisk -VM $newVM `
   -Name $disk.Name `
   -ManagedDiskId $disk.ManagedDisk.Id `
   -Caching $disk.Caching `
   -Lun $disk.Lun `
   -DiskSizeInGB $disk.DiskSizeGB `
   -CreateOption Attach
}

# Add NIC(s) and keep the same NIC as primary; keep the Private IP too, if it exists. 
foreach ($nic in $originalVM.NetworkProfile.NetworkInterfaces) {	
if ($nic.Primary -eq "True")
{
        Add-AzVMNetworkInterface `
           -VM $newVM `
           -Id $nic.Id -Primary
           }
       else
           {
             Add-AzVMNetworkInterface `
            -VM $newVM `
             -Id $nic.Id 
            }
  }

# Recreate the VM
New-AzVM `
   -ResourceGroupName $resourceGroup `
   -Location $originalVM.Location `
   -VM $newVM `
   -DisableBginfoExtension
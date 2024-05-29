# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave -Scope Process | Out-Null
$AzureContext = (Connect-AzAccount -Identity).context
# set and store context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext
#$Random = Get-Random -Maximum 99
#$VMname = "azcsghrunner" + $Random
#Write-Output $VMname

$nics =
   Get-AzNetworkInterface |
   Where-Object {
     ($_.ResourceGroupName -eq 'owscs-rsg-runners') -And
     ($_.VirtualMachine -eq $null) -And
     (($_.PrivateEndpointText -eq $null) -Or
      ($_.PrivateEndpointText -eq 'null'))}

foreach ($nic in $nics)
{
 Write-Host
     "Removing Orphaned NIC $($nic.Name) $($nic.resourcegroupname)"
Remove-AzNetworkInterface `
  -Name $nic.Name `
  -ResourceGroupName $nic.resourcegroupname `
  -Force 
}
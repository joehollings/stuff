<#
#Install Server roles
Install-WindowsFeature Failover-clustering -IncludeManagementTools
Install-WindowsFeature FS-Resource-Manager -IncludeManagementTools
Install-WindowsFeature Storage-Replica -IncludeManagementTools -Restart
#>

$ClusterName = "NCL10011CLU01"
$NCLNode01 = "NCL10011FSC01"
$NCLNode02 = "NCL10011FSC02"
$SHFNode01 = "SHF10011FSC01"
$NCL_IP = "192.168.44.60"
$SHF_IP = "172.16.44.60"
$FSRoleName = "CLU10011FS01"
$NCLRoleIP = "192.168.44.61"
$SHFRoleIP = "172.16.44.61"
$AzureAccount = "owsfswitness"
$AzureKey = "02weTjniUm9jUZCLaMLsyU2gg89kLB0rUK/CjBPZg+18lCytFXKdvtWn03XZ/c9bC9EfAygfjmpnB1apWNFecw=="

#Create Cluster
New-Cluster -Name $ClusterName -Node $NCLNode01, $NCLNode02 -StaticAddress $NCL_IP
#Set Quorum to Azure File Share Witness
Set-ClusterQuorum -CloudWitness -AccountName $AzureAccount -AccessKey $AzureKey
#Renames Newcastle cluster disks
(Get-ClusterResource -Name "Cluster Disk 1").Name = "NCL_Log"
(Get-ClusterResource -Name "Cluster Disk 2").Name = "Data"
#Adds Sheffield Node
Add-ClusterNode $SHFNode01
(Get-ClusterNetwork -Name "Cluster Network 1").Name = "NCL Network"
(Get-ClusterNetwork -Name "Cluster Network 2").Name = "SHF Network"
Add-ClusterResource -Name "Cluster IP $SHF_IP" -ResourceType “IP Address” -Group “Cluster Group"
Get-ClusterResource “Cluster IP $SHF_IP” | Set-ClusterParameter –Multiple @{“Network”=”SHF Network”;”Address”=”$SHF_IP”;”SubnetMask”=”255.255.255.0”;”EnableDhcp”=0}
Set-ClusterResourceDependency -Resource "Cluster Name” -Dependency “[Cluster IP Address] or [Cluster IP $SHF_IP]”

#Add SHF cluster disks
Get-ClusterAvailableDisk -All | Add-ClusterDisk
(Get-ClusterResource -Name "Cluster Disk 1").Name = "Data_Replica"
(Get-ClusterResource -Name "Cluster Disk 2").Name = "SHF_Log"

#Configure site awareness
New-ClusterFaultDomain -Name NCL -Type Site -Description "Primary" -Location "Newcastle Data Centre"  
New-ClusterFaultDomain -Name SHF -Type Site -Description "Secondary" -Location "Sheffield Data Centre"  
Set-ClusterFaultDomain -Name $NCLNode01 -Parent NCL
Set-ClusterFaultDomain -Name $NCLNode02 -Parent NCL 
Set-ClusterFaultDomain -Name $SHFNode01 -Parent SHF
(Get-Cluster).PreferredSite="NCL"

#add cluster account to ad group so role can be created

Install-WindowsFeature RSAT-AD-PowerShell
$Group = Get-ADGroup "Clusters"
$Account = Get-ADComputer $FSRoleName
Add-ADGroupMember $Group -Members $Account
Remove-WindowsFeature RSAT-AD-PowerShell

#Configures File server role
Add-ClusterFileServerRole -Name $FSRoleName -Storage "Data" -StaticAddress $NCLRoleIP, $SHFRoleIP
#Add Directories for file shares here
mkdir D:\CTXProfiles
mkdir D:\Home
New-SmbShare -Name CTXProfiles -Path D:\CTXProfiles -ContinuouslyAvailable $true -CachingMode None
New-SmbShare -Name Home -Path D:\Home -ContinuouslyAvailable $true -CachingMode None
#Set TTL for cluster role DNS record to 5 min
Get-ClusterResource -Name $FSRoleName | Set-ClusterParameter -Name HostRecordTTL -Value 300
Get-ClusterResource -Name $FSRoleName | Stop-ClusterResource
Get-ClusterResource -Name $FSRoleName | Start-ClusterResource
Get-ClusterResource -Name "File Server (\\$FSRoleName)" | Start-ClusterResource
#Enables storage replication
New-SRPartnership -SourceComputerName $NCLNode01 -SourceRGName RG01 -SourceVolumeName d: -SourceLogVolumeName n: -DestinationComputerName $SHFNode01 -DestinationRGName RG02 -DestinationVolumeName d: -DestinationLogVolumeName s:
#Allow online resize of the data volume
Set-SRGroup -Name 'RG01' -AllowVolumeResize $true
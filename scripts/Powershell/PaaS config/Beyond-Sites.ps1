# Gets Sites
#Get-AdReplicationSite -filter *
# Gets Site Links
# Get-AdReplicationSiteLink -filter *
# Gets cidrs
# Get-AdReplicationcidr -filter *

$CSV = Import-Csv -Path "C:\temp\test.csv"

if (Get-AdReplicationSite -Identity "London" -eq $true) {
    Write-Host "London Exists"
}

# New-ADReplicationSite -Name "LondonHub"
# New-ADReplicationSite -Name "OhioHub"

foreach ($currentItemName in $CSV) {
    <# $currentItemName is the current item #>
    $DomainName = $currentItemName.domain
    $Location = $currentItemName.location
    $SiteName = "$Location-$DomainName"
    $Hub = "$Location" + "Hub"
    $Replink = "$SiteName-$Hub"
    $cidr = $currentItemName.cidr
    
    # Testing variables
    # Write-Host "$Location" 
    # Write-Host "$SiteName"
    # Write-Host "$cidr"
    # Write-Host "$Replink"
    # Write-Host "$Hub"

    New-ADReplicationSite -Name $SiteName
    New-ADReplicationcidr -Name $cidr -Site $SiteName
    New-ADReplicationSiteLink -Name "$Replink" -SitesIncluded "$SiteName","$Hub"
}
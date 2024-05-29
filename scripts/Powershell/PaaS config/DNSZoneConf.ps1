#DNS Secondary Zones

#Forward lookup Zones
Add-DnsServerSecondaryZone -MasterServers 10.0.2.1, 10.0.2.2 -Name MGMT.local -ZoneFile MGMT.local.dns -ComputerName $ComputerName
Add-DnsServerSecondaryZone -MasterServers 192.168.40.2, 192.168.40.3 -Name OWSCS.local -ZoneFile OWSCS.local.dns -ComputerName $ComputerName
Add-DnsServerSecondaryZone -MasterServers 192.168.42.2, 192.168.42.3 -Name SIEE.local -ZoneFile SIEE.local.dns -ComputerName $ComputerName
Add-DnsServerSecondaryZone -MasterServers 192.168.43.2, 192.168.43.3 -Name Howden.local -ZoneFile Howden.local.dns -ComputerName $ComputerName

#Reverse Lookup Zones

Add-DnsServerSecondaryZone -MasterServers 192.168.40.2, 192.168.40.3 -NetworkId 192.168.40.0/24 -ZoneFile OWSCS.local.dns -ComputerName $ComputerName
Add-DnsServerSecondaryZone -MasterServers 192.168.42.2, 192.168.42.3 -NetworkId 192.168.42.0/24 -ZoneFile SIEE.local.dns -ComputerName $ComputerName
Add-DnsServerSecondaryZone -MasterServers 192.168.43.2, 192.168.43.3 -NetworkId 192.168.43.0/24 -ZoneFile Howden.local.dns -ComputerName $ComputerName
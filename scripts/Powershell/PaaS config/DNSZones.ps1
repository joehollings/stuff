#Add new primary Zone (Reverse DNS)
Add-DnsServerPrimaryZone -NetworkId 192.168.40.0/24 -ReplicationScope Domain
Add-DnsServerPrimaryZone -NetworkId 192.168.42.0/24 -ReplicationScope Domain -ComputerName SHFMGTWDC01
Add-DnsServerPrimaryZone -NetworkId 192.168.43.0/24 -ReplicationScope Domain -ComputerName SHFMGTWDC01
Add-DnsServerPrimaryZone -NetworkId 192.168.44.0/24 -ReplicationScope Domain -ComputerName SHFMGTWDC01

Add-DnsServerPrimaryZone -NetworkId 172.16.40.0/24 -ReplicationScope Domain -ComputerName NCLMGTWDC02
Add-DnsServerPrimaryZone -NetworkId 172.16.42.0/24 -ReplicationScope Domain -ComputerName SHFMGTWDC01
Add-DnsServerPrimaryZone -NetworkId 172.16.43.0/24 -ReplicationScope Domain -ComputerName SHFMGTWDC02
Add-DnsServerPrimaryZone -NetworkId 172.16.44.0/24 -ReplicationScope Domain -ComputerName SHFMGTWDC02

#Forward Stub Zones
Add-DnsServerStubZone -MasterServers 192.168.42.2, 192.168.42.3 -Name SIEE.local -ReplicationScope Domain
Add-DnsServerStubZone -MasterServers 192.168.43.2, 192.168.43.3 -Name Howden.local -ReplicationScope Domain
Add-DnsServerStubZone -MasterServers 192.168.44.2,192.168.44.3 -Name Morgan.local -ReplicationScope Domain

#Reverse Stub Zones
Add-DnsServerStubZone -NetworkId 10.0.2.0/24 -MasterServers 10.0.2.1, 10.0.2.2 -ReplicationScope Domain
Add-DnsServerStubZone -NetworkId 192.168.42.0/24 -MasterServers 192.168.42.2, 192.168.42.3 -ReplicationScope Domain
Add-DnsServerStubZone -NetworkId 192.168.43.0/24 -MasterServers 192.168.43.2, 192.168.43.3 -ReplicationScope Domain
Add-DnsServerStubZone -NetworkId 192.168.44.0/24 -MasterServers 192.168.44.2, 192.168.44.3 -ReplicationScope Domain

#Zone transfers

#Forward
Set-DnsServerPrimaryZone -ComputerName NCLMGTWDC01, NCLMGTWDC02 -Name MGMT.local -Notify NotifyServers -NotifyServers 192.168.15.10, 192.168.15.9, 192.168.40.2, 192.168.40.3, 172.16.40.2, 172.16.40.3, 192.168.20.2, 192.168.20.3 -SecondaryServers 192.168.15.10, 192.168.15.9, 192.168.40.2, 192.168.40.3, 172.16.40.2, 172.16.40.3, 192.168.20.2, 192.168.20.3 -SecureSecondaries TransferToSecureServers
Set-DnsServerPrimaryZone -ComputerName NCLMGTWDC02 -Name OWSCS.net -Notify NotifyServers -NotifyServers 192.168.15.10, 192.168.15.9, 192.168.40.2, 192.168.40.3, 172.16.40.2, 172.16.40.3, 192.168.20.2, 192.168.20.3 -SecondaryServers 192.168.15.10, 192.168.15.9, 192.168.40.2, 192.168.40.3, 172.16.40.2, 172.16.40.3, 192.168.20.2, 192.168.20.3 -SecureSecondaries TransferToSecureServers
Set-DnsServerPrimaryZone -ComputerName NCLCSWDC02 -Name OWSCS.local -Notify NotifyServers -NotifyServers 10.0.2.1, 10.0.2.2, 172.16.2.1, 172.16.2.2, 192.168.15.10, 192.168.15.9 -SecondaryServers 10.0.2.1, 10.0.2.2, 172.16.2.1, 172.16.2.2, 192.168.15.10, 192.168.15.9 -SecureSecondaries TransferToSecureServers
Set-DnsServerPrimaryZone -ComputerName NCL10015WDC01 -Name Howden.local -Notify NotifyServers -NotifyServers 10.0.2.1, 10.0.2.2, 172.16.2.1, 172.16.2.2 -SecondaryServers 10.0.2.1, 10.0.2.2, 172.16.2.1, 172.16.2.2 -SecureSecondaries TransferToSecureServers
Set-DnsServerPrimaryZone -ComputerName NCL10011WDC01 -Name Morgan.local -Notify NotifyServers -NotifyServers 10.0.2.1, 10.0.2.2, 172.16.2.1, 172.16.2.2 -SecondaryServers 10.0.2.1, 10.0.2.2, 172.16.2.1, 172.16.2.2 -SecureSecondaries TransferToSecureServers
Set-DnsServerPrimaryZone -ComputerName NCL10027WDC01 -Name SIEE.local -Notify NotifyServers -NotifyServers 10.0.2.1, 10.0.2.2, 172.16.2.1, 172.16.2.2 -SecondaryServers 10.0.2.1, 10.0.2.2, 172.16.2.1, 172.16.2.2 -SecureSecondaries TransferToSecureServers

#Reverse
#Newcastle
Set-DnsServerPrimaryZone -Name 0.0.10.in-addr.arpa -Notify NotifyServers -NotifyServers 192.168.40.2, 192.168.40.3, 192.168.15.10, 192.168.15.9, 172.16.40.2, 172.16.40.3 -SecondaryServers 192.168.40.2, 192.168.40.3, 192.168.15.10, 192.168.15.9, 172.16.40.2, 172.16.40.3 -SecureSecondaries TransferToSecureServers -ComputerName NCLMGTWDC02
Set-DnsServerPrimaryZone -Name 1.0.10.in-addr.arpa -Notify NotifyServers -NotifyServers 192.168.40.2, 192.168.40.3, 192.168.15.10, 192.168.15.9, 172.16.40.2, 172.16.40.3 -SecondaryServers 192.168.40.2, 192.168.40.3, 192.168.15.10, 192.168.15.9, 172.16.40.2, 172.16.40.3 -SecureSecondaries TransferToSecureServers -ComputerName NCLMGTWDC02
Set-DnsServerPrimaryZone -Name 2.0.10.in-addr.arpa -Notify NotifyServers -NotifyServers 192.168.40.2, 192.168.40.3, 192.168.15.10, 192.168.15.9, 172.16.40.2, 172.16.40.3 -SecondaryServers 192.168.40.2, 192.168.40.3, 192.168.15.10, 192.168.15.9, 172.16.40.2, 172.16.40.3 -SecureSecondaries TransferToSecureServers -ComputerName NCLMGTWDC02
Set-DnsServerPrimaryZone -Name 3.0.10.in-addr.arpa -Notify NotifyServers -NotifyServers 192.168.40.2, 192.168.40.3, 192.168.15.10, 192.168.15.9, 172.16.40.2, 172.16.40.3 -SecondaryServers 192.168.40.2, 192.168.40.3, 192.168.15.10, 192.168.15.9, 172.16.40.2, 172.16.40.3 -SecureSecondaries TransferToSecureServers -ComputerName NCLMGTWDC02
Set-DnsServerPrimaryZone -Name 0.16.172.in-addr.arpa -Notify NotifyServers -NotifyServers 192.168.40.2, 192.168.40.3, 192.168.15.10, 192.168.15.9, 172.16.40.2, 172.16.40.3 -SecondaryServers 192.168.40.2, 192.168.40.3, 192.168.15.10, 192.168.15.9, 172.16.40.2, 172.16.40.3 -SecureSecondaries TransferToSecureServers -ComputerName NCLMGTWDC02
Set-DnsServerPrimaryZone -Name 1.16.172.in-addr.arpa -Notify NotifyServers -NotifyServers 192.168.40.2, 192.168.40.3, 192.168.15.10, 192.168.15.9, 172.16.40.2, 172.16.40.3 -SecondaryServers 192.168.40.2, 192.168.40.3, 192.168.15.10, 192.168.15.9, 172.16.40.2, 172.16.40.3 -SecureSecondaries TransferToSecureServers -ComputerName NCLMGTWDC02
Set-DnsServerPrimaryZone -Name 2.16.172.in-addr.arpa -Notify NotifyServers -NotifyServers 192.168.40.2, 192.168.40.3, 192.168.15.10, 192.168.15.9, 172.16.40.2, 172.16.40.3 -SecondaryServers 192.168.40.2, 192.168.40.3, 192.168.15.10, 192.168.15.9, 172.16.40.2, 172.16.40.3 -SecureSecondaries TransferToSecureServers -ComputerName NCLMGTWDC02
Set-DnsServerPrimaryZone -Name 3.16.172.in-addr.arpa -Notify NotifyServers -NotifyServers 192.168.40.2, 192.168.40.3, 192.168.15.10, 192.168.15.9, 172.16.40.2, 172.16.40.3 -SecondaryServers 192.168.40.2, 192.168.40.3, 192.168.15.10, 192.168.15.9, 172.16.40.2, 172.16.40.3 -SecureSecondaries TransferToSecureServers -ComputerName NCLMGTWDC02
Set-DnsServerPrimaryZone -Name 40.168.192.in-addr.arpa -Notify NotifyServers -NotifyServers 10.0.2.1, 10.0.2.2, 172.16.2.1, 172.16.2.2 -SecondaryServers 10.0.2.1, 10.0.2.2, 172.16.2.1, 172.16.2.2 -SecureSecondaries TransferToSecureServers
Set-DnsServerPrimaryZone -Name 42.168.192.in-addr.arpa -Notify NotifyServers -NotifyServers 10.0.2.1, 10.0.2.2, 172.16.2.1, 172.16.2.2 -SecondaryServers 10.0.2.1, 10.0.2.2, 172.16.2.1, 172.16.2.2 -SecureSecondaries TransferToSecureServers
Set-DnsServerPrimaryZone -Name 43.168.192.in-addr.arpa -Notify NotifyServers -NotifyServers 10.0.2.1, 10.0.2.2, 172.16.2.1, 172.16.2.2 -SecondaryServers 10.0.2.1, 10.0.2.2, 172.16.2.1, 172.16.2.2 -SecureSecondaries TransferToSecureServers
Set-DnsServerPrimaryZone -Name 44.168.192.in-addr.arpa -Notify NotifyServers -NotifyServers 10.0.2.1, 10.0.2.2, 172.16.2.1, 172.16.2.2 -SecondaryServers 10.0.2.1, 10.0.2.2, 172.16.2.1, 172.16.2.2 -SecureSecondaries TransferToSecureServers

#Sheffield
Set-DnsServerPrimaryZone -Name 0.16.172.in-addr.arpa -Notify NotifyServers -NotifyServers 192.168.40.2, 192.168.40.3, 192.168.15.10, 192.168.15.9, 172.16.40.2, 172.16.40.3 -SecondaryServers 192.168.40.2, 192.168.40.3, 192.168.15.10, 192.168.15.9, 172.16.40.2, 172.16.40.3 -SecureSecondaries TransferToSecureServers -ComputerName NCLMGTWDC02
Set-DnsServerPrimaryZone -Name 1.16.172.in-addr.arpa -Notify NotifyServers -NotifyServers 192.168.40.2, 192.168.40.3, 192.168.15.10, 192.168.15.9, 172.16.40.2, 172.16.40.3 -SecondaryServers 192.168.40.2, 192.168.40.3, 192.168.15.10, 192.168.15.9, 172.16.40.2, 172.16.40.3 -SecureSecondaries TransferToSecureServers -ComputerName NCLMGTWDC02
Set-DnsServerPrimaryZone -Name 2.16.172.in-addr.arpa -Notify NotifyServers -NotifyServers 192.168.40.2, 192.168.40.3, 192.168.15.10, 192.168.15.9, 172.16.40.2, 172.16.40.3 -SecondaryServers 192.168.40.2, 192.168.40.3, 192.168.15.10, 192.168.15.9, 172.16.40.2, 172.16.40.3 -SecureSecondaries TransferToSecureServers -ComputerName NCLMGTWDC02
Set-DnsServerPrimaryZone -Name 3.16.172.in-addr.arpa -Notify NotifyServers -NotifyServers 192.168.40.2, 192.168.40.3, 192.168.15.10, 192.168.15.9, 172.16.40.2, 172.16.40.3 -SecondaryServers 192.168.40.2, 192.168.40.3, 192.168.15.10, 192.168.15.9, 172.16.40.2, 172.16.40.3 -SecureSecondaries TransferToSecureServers -ComputerName NCLMGTWDC02
Set-DnsServerPrimaryZone -Name 40.16.172.in-addr.arpa -Notify NotifyServers -NotifyServers 10.0.2.1, 10.0.2.2, 172.16.2.1, 172.16.2.2 -SecondaryServers 10.0.2.1, 10.0.2.2, 172.16.2.1, 172.16.2.2 -SecureSecondaries TransferToSecureServers
Set-DnsServerPrimaryZone -Name 43.16.172.in-addr.arpa -Notify NotifyServers -NotifyServers 10.0.2.1, 10.0.2.2, 172.16.2.1, 172.16.2.2 -SecondaryServers 10.0.2.1, 10.0.2.2, 172.16.2.1, 172.16.2.2 -SecureSecondaries TransferToSecureServers
Set-DnsServerPrimaryZone -Name 44.16.172.in-addr.arpa -Notify NotifyServers -NotifyServers 10.0.2.1, 10.0.2.2, 172.16.2.1, 172.16.2.2 -SecondaryServers 10.0.2.1, 10.0.2.2, 172.16.2.1, 172.16.2.2 -SecureSecondaries TransferToSecureServers

#DNS Secondary Zones

#Forward Secondary lookup Zones
#Newcastle
Add-DnsServerSecondaryZone -MasterServers 10.0.2.1, 10.0.2.2 -Name MGMT.local -ZoneFile MGMT.local.dns -ComputerName NCLCSWDC02
Add-DnsServerSecondaryZone -MasterServers 192.168.40.2, 192.168.40.3 -Name OWSCS.local -ZoneFile OWSCS.local.dns -ComputerName
Add-DnsServerSecondaryZone -MasterServers 10.0.2.1, 10.0.2.2 -Name OWSCS.net -ZoneFile OWSCS.net.dns
Add-DnsServerSecondaryZone -MasterServers 192.168.42.2, 192.168.42.3 -Name SIEE.local -ZoneFile SIEE.local.dns -ComputerName 
Add-DnsServerSecondaryZone -MasterServers 192.168.43.2, 192.168.43.3 -Name Howden.local -ZoneFile Howden.local.dns -ComputerName NCLCSWDC02
Add-DnsServerSecondaryZone -MasterServers 192.168.44.2,192.168.44.3 -Name Morgan.local -ZoneFile Morgan.local.dns -ComputerName NCLCSWDC02

#Reverse Secondary Lookup Zones
#Newcastle
Add-DnsServerSecondaryZone -MasterServers 10.0.2.1, 10.0.2.2 -NetworkId 10.0.0.0/24 -ZoneFile MGMT.local.dns
Add-DnsServerSecondaryZone -MasterServers 10.0.2.1, 10.0.2.2 -NetworkId 10.0.1.0/24 -ZoneFile MGMT.local.dns
Add-DnsServerSecondaryZone -MasterServers 10.0.2.1, 10.0.2.2 -NetworkId 10.0.2.0/24 -ZoneFile MGMT.local.dns
Add-DnsServerSecondaryZone -MasterServers 10.0.2.1, 10.0.2.2 -NetworkId 10.0.3.0/24 -ZoneFile MGMT.local.dns
Add-DnsServerSecondaryZone -MasterServers 192.168.40.2, 192.168.40.3 -NetworkId 192.168.40.0/24 -ZoneFile OWSCS.local.dns -ComputerName SHFMGTWDC02
Add-DnsServerSecondaryZone -MasterServers 192.168.42.2, 192.168.42.3 -NetworkId 192.168.42.0/24 -ZoneFile SIEE.local.dns -ComputerName SHFMGTWDC02
Add-DnsServerSecondaryZone -MasterServers 192.168.43.2, 192.168.43.3 -NetworkId 192.168.43.0/24 -ZoneFile Howden.local.dns -ComputerName SHFMGTWDC02
Add-DnsServerSecondaryZone -MasterServers 192.168.44.2, 192.168.44.2 -NetworkId 192.168.44.0/24 -ZoneFile Morgan.local.dns -ComputerName SHFMGTWDC02
#Sheffield
Add-DnsServerSecondaryZone -MasterServers 10.0.2.1, 10.0.2.2 -NetworkId 172.16.0.0/24 -ZoneFile MGMT.local.dns
Add-DnsServerSecondaryZone -MasterServers 10.0.2.1, 10.0.2.2 -NetworkId 172.16.1.0/24 -ZoneFile MGMT.local.dns
Add-DnsServerSecondaryZone -MasterServers 10.0.2.1, 10.0.2.2 -NetworkId 172.16.2.0/24 -ZoneFile MGMT.local.dns
Add-DnsServerSecondaryZone -MasterServers 10.0.2.1, 10.0.2.2 -NetworkId 172.16.3.0/24 -ZoneFile MGMT.local.dns
Add-DnsServerSecondaryZone -MasterServers 172.16.2.1, 172.16.2.2 -NetworkId 172.16.0.0/24 -ZoneFile MGMT.local.dns
Add-DnsServerSecondaryZone -MasterServers 172.16.2.1, 172.16.2.2 -NetworkId 172.16.1.0/24 -ZoneFile MGMT.local.dns
Add-DnsServerSecondaryZone -MasterServers 172.16.2.1, 172.16.2.2 -NetworkId 172.16.2.0/24 -ZoneFile MGMT.local.dns
Add-DnsServerSecondaryZone -MasterServers 172.16.2.1, 172.16.2.2 -NetworkId 172.16.3.0/24 -ZoneFile MGMT.local.dns
Add-DnsServerSecondaryZone -MasterServers 192.168.43.2, 192.168.43.3 -NetworkId 172.16.43.0/24 -ZoneFile Howden.local.dns -ComputerName SHFMGTWDC02
Add-DnsServerSecondaryZone -MasterServers 192.168.44.2, 192.168.44.2 -NetworkId 172.16.44.0/24 -ZoneFile Morgan.local.dns -ComputerName SHFMGTWDC02






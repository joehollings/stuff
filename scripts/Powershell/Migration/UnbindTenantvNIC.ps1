Disable-NetAdapterBinding -Name "vEthernet (Morgan)" -AllBindings
Disable-NetAdapterBinding -Name "vEthernet (OWS)" -AllBindings
Disable-NetAdapterBinding -Name "vEthernet (OWS - Old)" -AllBindings
Disable-NetAdapterBinding -Name "vEthernet (BPCCloud)" -AllBindings
Disable-NetAdapterBinding -Name "vEthernet (Howden)" -AllBindings
Disable-NetAdapterBinding -Name "vEthernet (DMZ13)" -AllBindings
Disable-NetAdapterBinding -Name "vEthernet (DMZ14)" -AllBindings
Disable-NetAdapterBinding -Name "vEthernet (DMZ)" -AllBindings
Disable-NetAdapterBinding -Name "vEthernet (OWSCS)" -AllBindings
Disable-NetAdapterBinding -Name "vEthernet (SIEE)" -AllBindings
Disable-NetAdapterBinding -Name "vEthernet (HanaDB)" -AllBindings
Disable-NetAdapterBinding -Name "vEthernet (Test)" -AllBindings
Set-NetIPInterface -InterfaceAlias "vEthernet (Morgan)" -Dhcp Disabled
Set-NetIPInterface -InterfaceAlias "vEthernet (OWS)" -Dhcp Disabled
Set-NetIPInterface -InterfaceAlias "vEthernet (OWS - Old)" -Dhcp Disabled
Set-NetIPInterface -InterfaceAlias "vEthernet (BPCCloud)" -Dhcp Disabled
Set-NetIPInterface -InterfaceAlias "vEthernet (Howden)" -Dhcp Disabled
Set-NetIPInterface -InterfaceAlias "vEthernet (DMZ13)" -Dhcp Disabled
Set-NetIPInterface -InterfaceAlias "vEthernet (DMZ14)" -Dhcp Disabled
Set-NetIPInterface -InterfaceAlias "vEthernet (DMZ)" -Dhcp Disabled
Set-NetIPInterface -InterfaceAlias "vEthernet (OWSCS)" -Dhcp Disabled
Set-NetIPInterface -InterfaceAlias "vEthernet (SIEE)" -Dhcp Disabled
Set-NetIPInterface -InterfaceAlias "vEthernet (HanaDB)" -Dhcp Disabled
Set-NetIPInterface -InterfaceAlias "vEthernet (Test)" -Dhcp Disabled
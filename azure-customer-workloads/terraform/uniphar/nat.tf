resource "azurerm_virtual_network_gateway_nat_rule" "egress" {
  name                       = "azure-uniphar"
  resource_group_name        = azurerm_resource_group.prod.name
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpn.id
  mode                       = "EgressSnat"
  type                       = "Static"

  external_mapping {
    address_space = "172.30.22.4/32"
  }

  internal_mapping {
    address_space = "10.11.22.4/32"
  }
}

resource "azurerm_virtual_network_gateway_nat_rule" "ingress" {
  name                       = "uniphar-azure"
  resource_group_name        = azurerm_resource_group.prod.name
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpn.id
  mode                       = "IngressSnat"
  type                       = "Static"

  external_mapping {
    address_space = "10.11.22.4/32"
  }

  internal_mapping {
    address_space = "172.30.22.4/32"
  }
}
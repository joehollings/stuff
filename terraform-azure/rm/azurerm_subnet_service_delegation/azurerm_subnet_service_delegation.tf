resource "azurerm_subnet" "subnet_service_delegation" {

  resource_group_name = var.resource_group_name

  name                 = var.name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.address_prefixes

  delegation {
    name = var.delegation_name

    service_delegation {
      name    = var.service_delegation_name
      actions = var.service_delegation_actions
    }
  }
}

output "subnet" {
  value = azurerm_subnet.subnet_service_delegation
}

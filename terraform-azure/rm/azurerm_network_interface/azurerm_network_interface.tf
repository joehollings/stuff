resource "azurerm_network_interface" "network_interface" {

  resource_group_name            = var.resource_group_name
  location                       = var.location
  name                           = var.name
  ip_forwarding_enabled          = var.ip_forwarding_enabled
  accelerated_networking_enabled = var.accelerated_networking_enabled
  tags                           = var.tags

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = var.ip_configuration_subnet_id
    private_ip_address_allocation = var.ip_configuration_private_ip_address_allocation
    private_ip_address            = var.ip_configuration_private_ip_address
    public_ip_address_id          = var.ip_configuration_public_ip_address_id
  }
}

output "network_interface" {
  value = azurerm_network_interface.network_interface
}

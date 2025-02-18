resource "azurerm_network_security_rule" "network_security_rule" {

  resource_group_name = var.resource_group_name

  name                        = var.name
  network_security_group_name = var.network_security_group_name

  priority                   = var.priority
  direction                  = var.direction
  access                     = var.access
  protocol                   = var.protocol
  source_port_range          = var.source_port_range
  destination_port_ranges    = var.destination_port_ranges
  source_address_prefixes    = var.source_address_prefixes
  destination_address_prefix = var.destination_address_prefix
}

output "network_security_rule" {
  value = azurerm_network_security_rule.network_security_rule
}

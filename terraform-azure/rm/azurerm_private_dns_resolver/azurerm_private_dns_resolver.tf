resource "azurerm_private_dns_resolver" "private_dns_resolver" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_network_id  = var.virtual_network_id
  tags                = var.tags
}

output "private_dns_resolver" {
  value = azurerm_private_dns_resolver.private_dns_resolver
}
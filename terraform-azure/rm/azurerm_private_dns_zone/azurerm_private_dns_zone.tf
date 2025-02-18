resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = var.name
  resource_group_name = var.resource_group_name
}

output "private_dns_zone" {
  value = azurerm_private_dns_zone.private_dns_zone
}
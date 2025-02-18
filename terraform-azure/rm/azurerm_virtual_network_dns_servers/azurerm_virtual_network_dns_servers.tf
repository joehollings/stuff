resource "azurerm_virtual_network_dns_servers" "virtual_network_dns_servers" {
  virtual_network_id = var.virtual_network_id
  dns_servers        = var.dns_servers
}

output "virtual_network_dns_servers" {
  value = azurerm_virtual_network_dns_servers.virtual_network_dns_servers
}
resource "azurerm_private_dns_resolver_inbound_endpoint" "private_dns_resolver_inbound_endpoint" {
  name                    = var.name
  private_dns_resolver_id = var.private_dns_resolver_id
  location                = var.location
  ip_configurations {
    private_ip_allocation_method = var.ip_configurations_private_ip_allocation_method
    subnet_id                    = var.private_ip_allocation_method_subnet_id
  }
  tags = var.tags
}

output "private_dns_resolver_inbound_endpoint" {
  value = azurerm_private_dns_resolver_inbound_endpoint.private_dns_resolver_inbound_endpoint
}
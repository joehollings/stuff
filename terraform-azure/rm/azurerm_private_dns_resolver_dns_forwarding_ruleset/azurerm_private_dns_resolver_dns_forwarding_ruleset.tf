resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "private_dns_resolver_dns_forwarding_ruleset" {
  name                                       = var.name
  resource_group_name                        = var.resource_group_name
  location                                   = var.location
  private_dns_resolver_outbound_endpoint_ids = var.private_dns_resolver_outbound_endpoint_ids
  tags                                       = var.tags
}

output "private_dns_resolver_dns_forwarding_ruleset" {
  value = azurerm_private_dns_resolver_dns_forwarding_ruleset.private_dns_resolver_dns_forwarding_ruleset
}
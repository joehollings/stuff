resource "azurerm_private_dns_resolver_forwarding_rule" "private_dns_resolver_forwarding_rule" {
  name                      = var.name
  dns_forwarding_ruleset_id = var.dns_forwarding_ruleset_id
  domain_name               = var.domain_name
  enabled                   = var.enabled
  target_dns_servers {
    ip_address = var.dns_server_primary_ip_address
    port       = 53
  }
  target_dns_servers {
    ip_address = var.dns_server_secondary_ip_address
    port       = 53
  }
  metadata = var.metadata
}

output "private_dns_resolver_forwarding_rule" {
  value = azurerm_private_dns_resolver_forwarding_rule.private_dns_resolver_forwarding_rule
}
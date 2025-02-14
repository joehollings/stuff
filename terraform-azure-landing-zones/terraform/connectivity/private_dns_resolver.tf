# # Private DNS Resolver
# module "module_private_dns_resolver" {
#   source = "../../azure/rm/azurerm_private_dns_resolver"

#   name                = "kab-dpr-uksouth"
#   resource_group_name = "kab-connectivity-uksouth" # same rg as firewall
#   location            = var.connectivity_resources_location
#   virtual_network_id  = data.azurerm_virtual_network.kab-hub-uksouth.id
# }
# # Private DNS Resolver delegated subnets
# module "module_subnet_service_delegation" {
#   source   = "../../azure/rm/azurerm_subnet_service_delegation"
#   for_each = local.subnets

#   name                       = each.key
#   resource_group_name        = "kab-connectivity-uksouth" # same rg as firewall
#   vnet_name                  = "kab-hub-uksouth"          # hub vnet
#   address_prefixes           = each.value.address_prefixes
#   delegation_name            = "Microsoft.Network.dnsResolvers"
#   service_delegation_name    = "Microsoft.Network/dnsResolvers"
#   service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
# }
# # Private DNS Resolver endpoints
# module "module_private_dns_resolver_inbound_endpoint" {
#   source = "../../azure/rm/azurerm_private_dns_resolver_inbound_endpoint"

#   name                                   = "inbounddns"
#   location                               = var.connectivity_resources_location
#   private_dns_resolver_id                = module.module_private_dns_resolver.private_dns_resolver.id
#   private_ip_allocation_method_subnet_id = module.module_subnet_service_delegation["inbounddns"].subnet.id
#   tags                                   = local.tags
# }
# module "module_private_dns_resolver_outbound_endpoint" {
#   source = "../../azure/rm/azurerm_private_dns_resolver_outbound_endpoint"

#   name                    = "outbounddns"
#   location                = var.connectivity_resources_location
#   private_dns_resolver_id = module.module_private_dns_resolver.private_dns_resolver.id
#   subnet_id               = module.module_subnet_service_delegation["outbounddns"].subnet.id
#   tags                    = local.tags
# }
# # Private DNS Resolver vnet links
# module "module_private_dns_resolver_virtual_network_link" {
#   source = "../../azure/rm/azurerm_private_dns_resolver_virtual_network_link"

#   name                      = "hub-link"
#   dns_forwarding_ruleset_id = module.module_private_dns_resolver_dns_forwarding_ruleset.private_dns_resolver_dns_forwarding_ruleset.id
#   virtual_network_id        = data.azurerm_virtual_network.kab-hub-uksouth.id # hub vnet
# }
# # Private DNS Resolver rule set
# module "module_private_dns_resolver_dns_forwarding_ruleset" {
#   source = "../../azure/rm/azurerm_private_dns_resolver_dns_forwarding_ruleset"

#   name                                       = "kab-hub-uksouth"
#   resource_group_name                        = "kab-connectivity-uksouth" # same rg as firewall
#   location                                   = var.connectivity_resources_location
#   private_dns_resolver_outbound_endpoint_ids = [module.module_private_dns_resolver_outbound_endpoint.private_dns_resolver_outbound_endpoint.id]
# }

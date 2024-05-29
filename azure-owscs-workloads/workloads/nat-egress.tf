# resource "azurerm_virtual_network_gateway_nat_rule" "sharedresources-egress" {
#   name                       = "sharedresources-egress"
#   resource_group_name        = data.azurerm_virtual_network_gateway.prod.resource_group_name
#   virtual_network_gateway_id = data.azurerm_virtual_network_gateway.prod.id
#   mode                       = "EgressSnat"
#   type                       = "Static"

#   internal_mapping {
#     address_space = "10.110.1.0/24"
#   }

#   external_mapping {
#     address_space = "10.10.1.0/24"
#   }

# }
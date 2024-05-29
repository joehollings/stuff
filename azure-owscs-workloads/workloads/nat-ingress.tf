# resource "azurerm_virtual_network_gateway_nat_rule" "sharedresources-ingress" {
#   name                       = "sharedresources-ingress"
#   resource_group_name        = data.azurerm_virtual_network_gateway.prod.resource_group_name
#   virtual_network_gateway_id = data.azurerm_virtual_network_gateway.prod.id
#   mode                       = "IngressSnat"
#   type                       = "Static"

#   external_mapping {
#     address_space = "10.110.1.0/24"
#   }

#   internal_mapping {
#     address_space = "10.10.1.0/24"
#   }
# }
# Resource group for connectivity resources
module "module_resource_group_connectivity" {
  source = "../../azure/rm/azurerm_resource_group"

  name     = "kab-identity-connectivity-${var.location}"
  location = var.location
  tags = {
    customer    = "Kabeelah",
    project     = "Kabeelah Cloud",
    environment = "prod"
  }
}
# Identity VNet
module "module_virtual_networks" {
  source = "../../azure/rm/azurerm_virtual_network"

  resource_group_name = module.module_resource_group_connectivity.resource_group.name
  location            = var.location
  name                = "kab-identity-${var.location}"
  address_space       = ["10.0.0.0/24"]
  tags = {
    customer    = "Kabeelah",
    project     = "Kabeelah Cloud",
    environment = "prod"
  }
}
# vNet Peer to Hub vNet
module "virtual_network_peering" {
  source = "../../azure/rm/azurerm_virtual_network_peering"

  resource_group_name          = module.module_resource_group_connectivity.resource_group.name
  name                         = "peer-identity-hub"
  virtual_network_name         = module.module_virtual_networks.virtual_network.name
  remote_virtual_network_id    = var.kab-hub-uksouth_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
  allow_gateway_transit        = false
}
# Identity subnet
module "module_subnets" {
  source = "../../azure/rm/azurerm_subnet"

  resource_group_name = module.module_resource_group_connectivity.resource_group.name
  name                = "Identity"
  vnet_name           = module.module_virtual_networks.virtual_network.name
  address_prefixes    = ["10.0.0.0/24"]

}
# NSG
module "module_nsg" {
  source              = "../../azure/rm/azurerm_network_security_group"
  resource_group_name = module.module_resource_group_connectivity.resource_group.name
  location            = var.location
  name                = "identity-nsg"
}
# NSG subnet association
module "module_nsg_association" {
  source                    = "../../azure/rm/azurerm_subnet_network_security_group_association"
  subnet_id                 = module.module_subnets.subnet.id
  network_security_group_id = module.module_nsg.network_security_group.id
}

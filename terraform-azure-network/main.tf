resource "azurerm_virtual_network" "this" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space

  tags = {
    Customer    = var.tags_customer
    environment = var.tags_environment
    Project     = var.tags_project
  }
}

resource "azurerm_subnet" "this" {
  for_each             = var.subnets
  name                 = each.key
  address_prefixes     = lookup(each.value, "address_prefixes", [])
  resource_group_name  = azurerm_virtual_network.this.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
}

resource "azurerm_virtual_network_peering" "peer" {
  name                         = "${var.remote_virtual_network_name}-peer-${azurerm_virtual_network.this.name}"
  resource_group_name          = var.remote_resource_group_name
  virtual_network_name         = var.remote_virtual_network_name
  remote_virtual_network_id    = azurerm_virtual_network.this.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = var.allow_gateway_transit # Remove for testing if test hub has no gateway
}

resource "azurerm_virtual_network_peering" "this" {
  name                         = "${azurerm_virtual_network.this.name}-peer-${var.remote_virtual_network_name}"
  resource_group_name          = azurerm_virtual_network.this.resource_group_name
  virtual_network_name         = azurerm_virtual_network.this.name
  remote_virtual_network_id    = var.remote_virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = var.allow_gateway_transit # Remove for testing if test hub has no gateway
}
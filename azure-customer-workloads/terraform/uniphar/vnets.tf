resource "azurerm_virtual_network" "prod" {
  name                = "10${local.customer_number}-vnet-sap-prod"
  location            = azurerm_resource_group.prod.location
  resource_group_name = azurerm_resource_group.prod.name
  address_space       = local.address_space_prod

  tags = {
    customer    = local.customer_name
    environment = "prod"
    project     = "10${local.customer_number}"
  }
}

resource "azurerm_subnet" "snet-presentation-prod" {
  name                 = "snet-presentation-prod"
  address_prefixes     = local.snet-presentation-prod
  resource_group_name  = azurerm_virtual_network.prod.resource_group_name
  virtual_network_name = azurerm_virtual_network.prod.name
}

resource "azurerm_subnet" "snet-sap-prod" {
  name                 = "snet-sap-prod"
  address_prefixes     = local.snet-sap-prod
  resource_group_name  = azurerm_virtual_network.prod.resource_group_name
  virtual_network_name = azurerm_virtual_network.prod.name
}

resource "azurerm_subnet" "snet-db-prod" {
  name                 = "snet-db-prod"
  address_prefixes     = local.snet-db-prod
  resource_group_name  = azurerm_virtual_network.prod.resource_group_name
  virtual_network_name = azurerm_virtual_network.prod.name
}

resource "azurerm_virtual_network_peering" "peer" {
  name                         = "${data.azurerm_virtual_network.vnet-hub.name}-peer-${azurerm_virtual_network.prod.name}"
  resource_group_name          = data.azurerm_virtual_network.vnet-hub.resource_group_name
  virtual_network_name         = data.azurerm_virtual_network.vnet-hub.name
  remote_virtual_network_id    = azurerm_virtual_network.prod.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = local.allow_gateway_transit
}

resource "azurerm_virtual_network_peering" "prod" {
  name                         = "${azurerm_virtual_network.prod.name}-peer-${data.azurerm_virtual_network.vnet-hub.name}"
  resource_group_name          = azurerm_virtual_network.prod.resource_group_name
  virtual_network_name         = azurerm_virtual_network.prod.name
  remote_virtual_network_id    = data.azurerm_virtual_network.vnet-hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = local.allow_gateway_transit
}

resource "azurerm_virtual_network" "dev" {
  name                = "10${local.customer_number}-vnet-sap-dev"
  location            = azurerm_resource_group.prod.location
  resource_group_name = azurerm_resource_group.prod.name
  address_space       = local.address_space_dev

  tags = {
    customer    = local.customer_name
    environment = "dev"
    project     = "10${local.customer_number}"
  }
}

resource "azurerm_subnet" "snet-presentation-dev" {
  name                 = "snet-presentation-dev"
  address_prefixes     = local.snet-presentation-dev
  resource_group_name  = azurerm_virtual_network.dev.resource_group_name
  virtual_network_name = azurerm_virtual_network.dev.name
}

resource "azurerm_subnet" "snet-sap-dev" {
  name                 = "snet-sap-dev"
  address_prefixes     = local.snet-sap-dev
  resource_group_name  = azurerm_virtual_network.dev.resource_group_name
  virtual_network_name = azurerm_virtual_network.dev.name
}

resource "azurerm_subnet" "snet-db-dev" {
  name                 = "snet-db-dev"
  address_prefixes     = local.snet-db-dev
  resource_group_name  = azurerm_virtual_network.dev.resource_group_name
  virtual_network_name = azurerm_virtual_network.dev.name
}

resource "azurerm_virtual_network_peering" "peer-dev" {
  name                         = "${data.azurerm_virtual_network.vnet-hub.name}-peer-${azurerm_virtual_network.dev.name}"
  resource_group_name          = data.azurerm_virtual_network.vnet-hub.resource_group_name
  virtual_network_name         = data.azurerm_virtual_network.vnet-hub.name
  remote_virtual_network_id    = azurerm_virtual_network.dev.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = local.allow_gateway_transit
}

resource "azurerm_virtual_network_peering" "dev" {
  name                         = "${azurerm_virtual_network.dev.name}-peer-${data.azurerm_virtual_network.vnet-hub.name}"
  resource_group_name          = azurerm_virtual_network.dev.resource_group_name
  virtual_network_name         = azurerm_virtual_network.dev.name
  remote_virtual_network_id    = data.azurerm_virtual_network.vnet-hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = local.allow_gateway_transit
}
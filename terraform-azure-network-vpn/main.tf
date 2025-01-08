resource "azurerm_virtual_network" "backend" {
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
  resource_group_name  = azurerm_virtual_network.backend.resource_group_name
  virtual_network_name = azurerm_virtual_network.backend.name
}

resource "azurerm_virtual_network_peering" "peer" {
  name                         = "${var.remote_virtual_network_name}-peer-${azurerm_virtual_network.backend.name}"
  resource_group_name          = var.remote_resource_group_name
  virtual_network_name         = var.remote_virtual_network_name
  remote_virtual_network_id    = azurerm_virtual_network.backend.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

resource "azurerm_virtual_network_peering" "this" {
  name                         = "${azurerm_virtual_network.backend.name}-peer-${var.remote_virtual_network_name}"
  resource_group_name          = azurerm_virtual_network.backend.resource_group_name
  virtual_network_name         = azurerm_virtual_network.backend.name
  remote_virtual_network_id    = var.remote_virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
}

resource "azurerm_virtual_network" "frontend" {
  name                = var.vpn_name
  location            = azurerm_virtual_network.backend.location
  resource_group_name = azurerm_virtual_network.backend.resource_group_name
  address_space       = var.frontend_address_space

  tags = {
    Customer    = var.tags_customer
    environment = var.tags_environment
    Project     = var.tags_project
  }
}

resource "azurerm_subnet" "gatewaysubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_virtual_network.backend.resource_group_name
  virtual_network_name = azurerm_virtual_network.frontend.name
  address_prefixes     = var.gatewaysubnet
}

resource "azurerm_local_network_gateway" "this" {
  name                = var.lgw_name
  location            = azurerm_virtual_network.backend.location
  resource_group_name = azurerm_virtual_network.backend.resource_group_name
  gateway_address     = var.gateway_address
  address_space       = var.gateway_address_space

  tags = {
    Customer    = var.tags_customer
    environment = var.tags_environment
    Project     = var.tags_project
  }
}

resource "azurerm_public_ip" "this" {
  name                = var.pip_name
  location            = azurerm_virtual_network.backend.location
  resource_group_name = azurerm_virtual_network.backend.resource_group_name
  allocation_method   = var.allocation_method

  tags = {
    Customer    = var.tags_customer
    environment = var.tags_environment
    Project     = var.tags_project
  }
}

resource "azurerm_virtual_network_gateway" "this" {
  name                = var.vgw_name
  location            = azurerm_virtual_network.backend.location
  resource_group_name = azurerm_virtual_network.backend.resource_group_name

  type     = var.type
  vpn_type = var.vpn_type

  active_active = false
  enable_bgp    = false
  sku           = var.sku

  ip_configuration {
    public_ip_address_id          = azurerm_public_ip.this.id
    private_ip_address_allocation = var.private_ip_address_allocation
    subnet_id                     = azurerm_subnet.gatewaysubnet.id
  }

  tags = {
    Customer    = var.tags_customer
    environment = var.tags_environment
    Project     = var.tags_project
  }
}

resource "azurerm_virtual_network_peering" "backend" {
  name                         = "${azurerm_virtual_network.frontend.name}-peer-${azurerm_virtual_network.backend.name}"
  resource_group_name          = azurerm_virtual_network.backend.resource_group_name
  virtual_network_name         = azurerm_virtual_network.frontend.name
  remote_virtual_network_id    = azurerm_virtual_network.backend.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}

resource "azurerm_virtual_network_peering" "frontend" {
  name                         = "${azurerm_virtual_network.backend.name}-peer-${azurerm_virtual_network.frontend.name}"
  resource_group_name          = azurerm_virtual_network.backend.resource_group_name
  virtual_network_name         = azurerm_virtual_network.backend.name
  remote_virtual_network_id    = azurerm_virtual_network.frontend.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = true
}
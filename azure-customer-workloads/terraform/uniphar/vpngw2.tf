resource "azurerm_public_ip" "pip" {
  name                = "10${local.customer_number}-pip-prod"
  resource_group_name = azurerm_resource_group.prod.name
  location            = azurerm_resource_group.prod.location

  allocation_method = "Dynamic"
}

resource "azurerm_subnet" "gatewaysubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.prod.name
  virtual_network_name = data.azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.0.0/28"]
}

resource "azurerm_virtual_network_gateway" "vpn" {
  name                = "10${local.customer_number}-vpn-prod"
  resource_group_name = azurerm_resource_group.prod.name
  location            = azurerm_resource_group.prod.location

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw2"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gatewaysubnet.id
  }
}

resource "azurerm_local_network_gateway" "this" {
  name                = "10${local.customer_number}-lng-prod"
  resource_group_name = azurerm_resource_group.prod.name
  location            = azurerm_resource_group.prod.location
  gateway_address     = "89.101.228.97"
  address_space       = ["172.16.11.23/32", "172.16.11.33/32"]
}

resource "azurerm_virtual_network_gateway_connection" "onpremise" {
  name                = "onpremise"
  resource_group_name = azurerm_resource_group.prod.name
  location            = azurerm_resource_group.prod.location

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpn.id
  local_network_gateway_id   = azurerm_local_network_gateway.this.id

  ipsec_policy {
    dh_group         = "DHGroup14"
    ike_encryption   = "AES256"
    ike_integrity    = "SHA256"
    ipsec_encryption = "AES256"
    ipsec_integrity  = "SHA256"
    pfs_group        = "PFS14"
    sa_lifetime      = "3600"
  }

  egress_nat_rule_ids  = [azurerm_virtual_network_gateway_nat_rule.egress.id]
  ingress_nat_rule_ids = [azurerm_virtual_network_gateway_nat_rule.ingress.id]
  shared_key           = data.azurerm_key_vault_secret.vpn_pre_shared_key.value
}

data "azurerm_key_vault_secret" "vpn_pre_shared_key" {
  name         = local.vpn_pre_shared_key_secret_name
  key_vault_id = data.azurerm_key_vault.this.id
}
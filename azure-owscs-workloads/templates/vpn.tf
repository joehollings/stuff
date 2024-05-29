resource "azurerm_virtual_network_gateway_connection" "name" {
  name                = "vgw-name-onpremise"
  resource_group_name = data.azurerm_virtual_network_gateway.prod.resource_group_name
  location            = data.azurerm_virtual_network_gateway.prod.location

  type                       = "IPsec"
  virtual_network_gateway_id = data.azurerm_virtual_network_gateway.prod.id
  local_network_gateway_id   = azurerm_local_network_gateway.twosisters.id

  ipsec_policy {
    dh_group         = "DHGroup14"
    ike_encryption   = "AES256"
    ike_integrity    = "SHA256"
    ipsec_encryption = "AES256"
    ipsec_integrity  = "SHA256"
    pfs_group        = "PFS14"
    sa_lifetime      = "3600"
  }

  shared_key = data.azurerm_key_vault_secret.vpn_pre_shared_key.value
}

resource "azurerm_local_network_gateway" "name" {
  name                = "name-lng-prod"
  resource_group_name = data.azurerm_virtual_network_gateway.prod.resource_group_name
  location            = data.azurerm_virtual_network_gateway.prod.location
  gateway_address     = ""
  address_space       = [""]
}

data "azurerm_key_vault_secret" "vpn_pre_shared_key" {
  name         = "name-vpn-preshared-key"
  key_vault_id = data.azurerm_key_vault.this.id
}
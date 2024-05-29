resource "azurerm_virtual_network_gateway_connection" "aryzta" {
  name                = "vgw-aws-aryzta"
  resource_group_name = data.azurerm_virtual_network_gateway.prod.resource_group_name
  location            = data.azurerm_virtual_network_gateway.prod.location

  type                       = "IPsec"
  dpd_timeout_seconds        = "45"
  virtual_network_gateway_id = data.azurerm_virtual_network_gateway.prod.id
  local_network_gateway_id   = azurerm_local_network_gateway.aryzta.id

  ipsec_policy {
    dh_group         = "DHGroup2"
    ike_encryption   = "AES128"
    ike_integrity    = "SHA1"
    ipsec_encryption = "AES128"
    ipsec_integrity  = "SHA1"
    pfs_group        = "PFS2"
    sa_lifetime      = "3600"
  }

  # egress_nat_rule_ids  = [azurerm_virtual_network_gateway_nat_rule.sharedresources-egress.id]
  # ingress_nat_rule_ids = [azurerm_virtual_network_gateway_nat_rule.sharedresources-ingress.id]

  shared_key = data.azurerm_key_vault_secret.aryzta_vpn_pre_shared_key.value
}

resource "azurerm_local_network_gateway" "aryzta" {
  name                = "aryzta-lng-prod"
  resource_group_name = data.azurerm_virtual_network_gateway.prod.resource_group_name
  location            = data.azurerm_virtual_network_gateway.prod.location
  gateway_address     = "52.209.255.146"
  address_space       = ["10.11.14.0/24, 10.11.15.0/24"]
}

data "azurerm_key_vault_secret" "aryzta_vpn_pre_shared_key" {
  name         = "aryzta-vpn-preshared-key"
  key_vault_id = data.azurerm_key_vault.this.id
}
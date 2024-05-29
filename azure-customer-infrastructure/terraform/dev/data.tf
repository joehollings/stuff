# credential 
data "azurerm_key_vault" "this" {
  name                = local.key_vault_name
  resource_group_name = local.key_vault_resource_group_name
}

data "azurerm_key_vault_secret" "local_admin_password" {
  name         = local.admin_password_secret_name
  key_vault_id = data.azurerm_key_vault.this.id
}

data "azurerm_key_vault_secret" "suse_reg_code" {
  name         = local.suse_reg_code
  key_vault_id = data.azurerm_key_vault.this.id
}

# infrastructure data sources
data "azurerm_resource_group" "hub-rsg-prod" {
  name = local.key_vault_resource_group_name
}

data "azurerm_virtual_network" "vnet-hub" {
  name                = "vnet-hub"
  resource_group_name = data.azurerm_resource_group.hub-rsg-prod.name
}

data "azurerm_subnet" "snet-identityservices" {
  name                 = "snet-identityservices"
  virtual_network_name = data.azurerm_virtual_network.vnet-hub.name
  resource_group_name  = data.azurerm_resource_group.hub-rsg-prod.name
}

#image data sources
data "azurerm_image" "dc_cc" {
  name                = "svr2022"
  resource_group_name = "packer-rsg-prod"
}
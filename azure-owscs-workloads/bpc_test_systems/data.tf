# credential 
data "azurerm_key_vault" "this" {
  name                = "kv-owscs-hub"
  resource_group_name = "rg-owscs-hub"
}

data "azurerm_key_vault_secret" "local_admin_password" {
  name         = "OWSCS-Admin"
  key_vault_id = data.azurerm_key_vault.this.id
}

data "azurerm_key_vault_secret" "ad_admin_password" {
  name         = local.ad_admin_password_secret_name
  key_vault_id = data.azurerm_key_vault.this.id
}

data "azurerm_key_vault_secret" "suse_reg_code" {
  name         = local.suse_reg_code
  key_vault_id = data.azurerm_key_vault.this.id
}


# infrastructure data sources
data "azurerm_resource_group" "hub-rsg-prod" {
  name = "rg-owscs-hub"
}

data "azurerm_resource_group" "test" {
  name = "owscs-rsg-test"
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

data "azurerm_subnet" "snet-sharedresources" {
  name                 = "snet-sharedresources"
  virtual_network_name = data.azurerm_virtual_network.vnet-hub.name
  resource_group_name  = data.azurerm_resource_group.hub-rsg-prod.name
}

data "azurerm_subnet" "snet-db-test" {
  name                 = "snet-db-test"
  virtual_network_name = data.azurerm_virtual_network.vnet-hub.name
  resource_group_name  = data.azurerm_resource_group.hub-rsg-prod.name
}

data "azurerm_recovery_services_vault" "vault" {
  name                = "owscs-rsv-hub"
  resource_group_name = "owscs-rsg-hub"
}

data "azurerm_backup_policy_vm" "WeeklyVMBackup" {
  name                = "WeeklyVMBackup"
  recovery_vault_name = data.azurerm_recovery_services_vault.vault.name
  resource_group_name = data.azurerm_recovery_services_vault.vault.resource_group_name
}

# image data sources
data "azurerm_image" "bpc" {
  name                = "svr2022bpc"
  resource_group_name = "packer-rsg-prod"
}

data "azurerm_image" "vda" {
  name                = "win10o2013ao"
  resource_group_name = "packer-rsg-prod"
}

data "azurerm_image" "hana" {
  name                = "sles15sp3"
  resource_group_name = "packer-rsg-prod"
}

data "azurerm_image" "dc_cc" {
  name                = "svr2022"
  resource_group_name = "packer-rsg-prod"
}
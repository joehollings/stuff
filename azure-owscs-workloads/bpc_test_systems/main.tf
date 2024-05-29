resource "azurerm_proximity_placement_group" "sap_test" {
  name                = "owscs-ppg-bpc-test"
  location            = data.azurerm_resource_group.test.location
  resource_group_name = data.azurerm_resource_group.test.name

  tags = {
    environment = "Test"
    customer    = local.customer_name
    project     = "00000"
  }
}

module "bpc" {
  source                       = "github.com/OpalwaveSolutions/terraform-azure-windows-bpc?ref=v1.3.4"
  for_each                     = local.bpc
  computer_name                = "az${each.key}"
  location                     = data.azurerm_resource_group.test.location
  resource_group_name          = data.azurerm_resource_group.test.name
  subnet_name                  = each.value.subnet_name
  subnet_id                    = each.value.subnet_id
  zone                         = each.value.zone
  size                         = each.value.size
  proximity_placement_group_id = each.value.proximity_placement_group_id
  source_image_id              = data.azurerm_image.bpc.id
  admin_username               = local.admin_username
  admin_password               = data.azurerm_key_vault_secret.local_admin_password.value
  active_directory_domain_name = "owscs.local"
  ad_admin_password            = data.azurerm_key_vault_secret.ad_admin_password.value
  ad_admin_username            = local.ad_admin_username
  managed_disk                 = lookup(each.value, "disks", {})
  rsv_rg_name                  = data.azurerm_recovery_services_vault.vault.resource_group_name
  recovery_vault_name          = data.azurerm_recovery_services_vault.vault.name
  backup_policy_id             = each.value.backup_policy_id
  tags_customer                = local.customer_name
  tags_environment             = "Test"
  tags_patching                = "Dev and Test"
  tags_project                 = "00000"
}

module "hana" {
  source                       = "github.com/OpalwaveSolutions/terraform-azure-linux-hana?ref=v1.3.2"
  for_each                     = local.hana
  location                     = data.azurerm_resource_group.test.location
  resource_group_name          = data.azurerm_resource_group.test.name
  computer_name                = each.key
  subnet_id                    = data.azurerm_subnet.snet-db-test.id
  subnet_name                  = data.azurerm_subnet.snet-db-test.name
  size                         = each.value.size
  zone                         = each.value.zone
  proximity_placement_group_id = each.value.proximity_placement_group_id
  source_image_id              = data.azurerm_image.hana.id
  admin_user                   = local.admin_username
  admin_password               = data.azurerm_key_vault_secret.local_admin_password.value
  hana_sid                     = each.value.hana_sid
  reg_code                     = data.azurerm_key_vault_secret.suse_reg_code.value
  managed_disk                 = lookup(each.value, "disks", {})
  tags_customer                = local.customer_name
  tags_environment             = "Test"
  tags_project                 = "00000"
}
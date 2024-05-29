resource "azurerm_proximity_placement_group" "solman" {
  name                = "owscs-ppg-solman-prod"
  location            = data.azurerm_resource_group.prod.location
  resource_group_name = data.azurerm_resource_group.prod.name

  tags = {
    environment = "Production"
    customer    = local.customer_name
    project     = "00000"
  }
}

module "solman" {
  source                       = "git@github.com:OpalwaveSolutions/terraform-azure-windows-bpc"
  for_each                     = local.sap
  computer_name                = "azcssol01"
  location                     = data.azurerm_resource_group.prod.location
  resource_group_name          = data.azurerm_resource_group.prod.name
  subnet_name                  = each.value.subnet_name
  subnet_id                    = each.value.subnet_id
  zone                         = each.value.zone
  size                         = each.value.size
  proximity_placement_group_id = each.value.proximity_placement_group_id
  source_image_id              = data.azurerm_image.bpc.id
  admin_username               = local.admin_username
  admin_password               = data.azurerm_key_vault_secret.local_admin_password.value
  managed_disk                 = lookup(each.value, "disks", {})
  rsv_rg_name                  = data.azurerm_recovery_services_vault.vault.resource_group_name
  recovery_vault_name          = data.azurerm_recovery_services_vault.vault.name
  backup_policy_id             = each.value.backup_policy_id
  tags_customer                = local.customer_name
  tags_environment             = "Prod"
  tags_patching                = "Prod"
  tags_project                 = "00000"
}

module "hana" {
  source                       = "git@github.com:OpalwaveSolutions/terraform-azure-linux-hana"
  for_each                     = local.hana
  location                     = data.azurerm_resource_group.prod.location
  resource_group_name          = data.azurerm_resource_group.prod.name
  computer_name                = "az${local.customer_number}${each.value.hana_sid}hdb01"
  subnet_id                    = data.azurerm_subnet.snet-db-prod.id
  subnet_name                  = data.azurerm_subnet.snet-db-prod.name
  size                         = each.value.size
  zone                         = each.value.zone
  proximity_placement_group_id = each.value.proximity_placement_group_id
  source_image_id              = data.azurerm_image.hana.id
  admin_user                   = local.admin_username
  admin_password               = data.azurerm_key_vault_secret.local_admin_password.value
  hana_sid                     = each.value.hana_sid
  install_script               = each.value.install_script
  managed_disk                 = lookup(each.value, "disks", {})
  tags_customer                = local.customer_name
  tags_environment             = each.key
  tags_project                 = "10${local.customer_number}"
}
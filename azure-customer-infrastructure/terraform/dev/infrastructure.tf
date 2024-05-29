module "storage" {
  source               = "github.com/OpalwaveSolutions/terraform-azure-storage-account?ref=v1.2.0"
  for_each             = local.storage_accounts
  storage_account_name = each.value.name
  resource_group_name  = azurerm_resource_group.prod.name
  location             = azurerm_resource_group.prod.location
  recovery_vault_name  = azurerm_recovery_services_vault.this.name
  storage_sid          = each.value.storage_sid
  shares               = lookup(each.value, "shares", {})
  tags_customer        = local.customer_name
  tags_environment     = each.key
  tags_project         = "10${local.customer_number}"
}

module "secondarydc" {
  source                       = "github.com/OpalwaveSolutions/terraform-azure-windows-dc-cc?ref=v1.2.2"
  computer_name                = "10${local.customer_number}wdc02"
  resource_group_name          = azurerm_resource_group.prod.name
  location                     = azurerm_resource_group.prod.location
  subnet_name                  = data.azurerm_subnet.snet-identityservices.name
  subnet_id                    = data.azurerm_subnet.snet-identityservices.id
  zone                         = "2"
  size                         = "Standard_B2s"
  license_type                 = "None"
  backup_policy_id             = azurerm_backup_policy_vm.WeeklyVMBackup.id
  source_image_id              = data.azurerm_image.dc_cc.id
  admin_username               = local.admin_username
  admin_password               = data.azurerm_key_vault_secret.local_admin_password.value
  active_directory_domain_name = local.customer_domain_name
  ad_admin_password            = data.azurerm_key_vault_secret.ad_admin_password.value
  ad_admin_username            = local.ad_admin_username
  rsv_rg_name                  = azurerm_resource_group.prod.name
  recovery_vault_name          = azurerm_recovery_services_vault.this.name
  tags_customer                = local.customer_name
  tags_environment             = "prod"
  tags_patching                = "prod"
  tags_project                 = "10${local.customer_number}"
}
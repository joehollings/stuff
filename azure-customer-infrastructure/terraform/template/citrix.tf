module "ccc" {
  source                       = "github.com/OpalwaveSolutions/terraform-azure-windows-dc-cc?ref=v1.2.2"
  for_each                     = local.citrixcloudconnectors
  computer_name                = each.value.computer_name
  resource_group_name          = azurerm_resource_group.prod.name
  location                     = azurerm_resource_group.prod.location
  subnet_name                  = data.azurerm_subnet.snet-identityservices.name
  subnet_id                    = data.azurerm_subnet.snet-identityservices.id
  zone                         = each.value.zone
  size                         = each.value.size
  source_image_id              = data.azurerm_image.dc_cc.id
  license_type                 = each.value.license_type
  admin_username               = local.admin_username
  admin_password               = data.azurerm_key_vault_secret.local_admin_password.value
  active_directory_domain_name = local.customer_domain_name
  ad_admin_password            = data.azurerm_key_vault_secret.ad_admin_password.value
  ad_admin_username            = local.ad_admin_username
  rsv_rg_name                  = azurerm_resource_group.prod.name
  recovery_vault_name          = azurerm_recovery_services_vault.this.name
  backup_policy_id             = each.value.backup_policy_id
  tags_customer                = local.customer_name
  tags_environment             = each.key
  tags_patching                = each.key
  tags_project                 = "10${local.customer_number}"
}

module "vda_templates" {
  source                       = "github.com/OpalwaveSolutions/terraform-azure-windows-vda?ref=v1.1.2"
  for_each                     = local.vda
  name                         = "az${local.customer_number}vda${each.key}template"
  computer_name                = "az${local.customer_number}vda${each.key}"
  resource_group_name          = azurerm_resource_group.prod.name
  location                     = azurerm_resource_group.prod.location
  subnet_name                  = azurerm_subnet.snet-presentation-prod.name
  subnet_id                    = azurerm_subnet.snet-presentation-prod.id
  zone                         = each.value.zone
  size                         = each.value.size
  source_image_id              = each.value.image_id
  admin_username               = local.admin_username
  admin_password               = data.azurerm_key_vault_secret.local_admin_password.value
  active_directory_domain_name = local.customer_domain_name
  ad_admin_password            = data.azurerm_key_vault_secret.ad_admin_password.value
  ad_admin_username            = local.ad_admin_username
  tags_customer                = local.customer_name
  tags_environment             = each.key
  tags_patching                = "Templates"
  tags_project                 = "10${local.customer_number}"
}
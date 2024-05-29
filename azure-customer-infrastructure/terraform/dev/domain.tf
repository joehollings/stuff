resource "azurerm_resource_group" "prod" {
  name     = "10${local.customer_number}-rsg-prod"
  location = local.location

  tags = {
    customer    = local.customer_name
    environment = "prod"
    project     = "10${local.customer_number}"
  }
}

module "primary_dc" {
  source                       = "github.com/OpalwaveSolutions/terraform-azure-windows-dc-cc?ref=v1.2.2"
  computer_name                = "10${local.customer_number}wdc01"
  resource_group_name          = azurerm_resource_group.prod.name
  location                     = azurerm_resource_group.prod.location
  subnet_name                  = data.azurerm_subnet.snet-identityservices.name
  subnet_id                    = data.azurerm_subnet.snet-identityservices.id
  zone                         = "1"
  size                         = "Standard_B2s"
  license_type                 = "None"
  backup_policy_id             = azurerm_backup_policy_vm.WeeklyVMBackup.id
  source_image_id              = data.azurerm_image.dc_cc.id
  admin_username               = local.admin_username
  admin_password               = data.azurerm_key_vault_secret.local_admin_password.value
  active_directory_domain_name = local.forest_root_domain
  ad_admin_password            = data.azurerm_key_vault_secret.ad_admin_password.value
  ad_admin_username            = local.ad_admin_username
  rsv_rg_name                  = azurerm_resource_group.prod.name
  recovery_vault_name          = azurerm_recovery_services_vault.this.name
  tags_customer                = local.customer_name
  tags_environment             = "prod"
  tags_patching                = "prod"
  tags_project                 = "10${local.customer_number}"
}
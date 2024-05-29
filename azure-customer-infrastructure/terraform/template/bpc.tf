resource "azurerm_proximity_placement_group" "dev" {
  name                = "10${local.customer_number}-ppg-sap-dev"
  location            = azurerm_resource_group.prod.location
  resource_group_name = azurerm_resource_group.prod.name
}

# resource "azurerm_proximity_placement_group" "qas" {
#   name                = "10${local.customer_number}-ppg-sap-qas"
#   location            = azurerm_resource_group.prod.location
#   resource_group_name = azurerm_resource_group.prod.name
# }

resource "azurerm_proximity_placement_group" "prod" {
  name                = "10${local.customer_number}-ppg-sap-prod"
  location            = azurerm_resource_group.prod.location
  resource_group_name = azurerm_resource_group.prod.name
}

module "bpc" {
  source                       = "github.com/OpalwaveSolutions/terraform-azure-windows-bpc?ref=v1.1.0"
  for_each                     = local.bpc
  computer_name                = "az${local.customer_number}${each.value.hana_sid}sap01"
  resource_group_name          = azurerm_resource_group.prod.name
  location                     = azurerm_resource_group.prod.location
  subnet_name                  = each.value.subnet_name
  subnet_id                    = each.value.subnet_id
  zone                         = each.value.zone
  size                         = each.value.size
  proximity_placement_group_id = each.value.proximity_placement_group_id
  source_image_id              = data.azurerm_image.bpc.id
  admin_username               = local.admin_username
  admin_password               = data.azurerm_key_vault_secret.local_admin_password.value
  managed_disk                 = lookup(each.value, "disks", {})
  rsv_rg_name                  = azurerm_resource_group.prod.name
  recovery_vault_name          = azurerm_recovery_services_vault.this.name
  backup_policy_id             = each.value.backup_policy_id
  tags_customer                = local.customer_name
  tags_environment             = each.key
  tags_patching                = each.key
  tags_project                 = "10${local.customer_number}"
}

module "hana" {
  source                       = "github.com/OpalwaveSolutions/terraform-azure-linux-hana?ref=v1.3.2"
  for_each                     = local.hana
  resource_group_name          = azurerm_resource_group.prod.name
  location                     = azurerm_resource_group.prod.location
  computer_name                = "az${local.customer_number}${each.value.hana_sid}hdb01"
  subnet_id                    = azurerm_subnet.snet-db-prod.id
  subnet_name                  = azurerm_subnet.snet-db-prod.name
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
  tags_environment             = each.key
  tags_project                 = "10${local.customer_number}"
}
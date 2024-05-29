resource "azurerm_virtual_network_dns_servers" "this" {
  virtual_network_id = data.azurerm_virtual_network.this.id
  dns_servers        = [data.azurerm_virtual_machine.dc01.private_ip_address, data.azurerm_virtual_machine.dc02.private_ip_address]
}

module "sun" {
  source                       = "github.com/OpalwaveSolutions/terraform-azure-windows-vm"
  for_each                     = local.sun
  computer_name                = "az${local.customer_number}app01"
  resource_group_name          = azurerm_resource_group.prod.name
  location                     = "uk south"
  subnet_name                  = each.value.subnet_name
  subnet_id                    = each.value.subnet_id
  zone                         = each.value.zone
  size                         = each.value.size
  proximity_placement_group_id = each.value.proximity_placement_group_id
  source_image_id              = data.azurerm_image.server2016.id
  admin_username               = local.admin_username
  admin_password               = data.azurerm_key_vault_secret.local_admin_password.value
  active_directory_domain_name = local.customer_domain_name
  ad_admin_password            = data.azurerm_key_vault_secret.ad_admin_password.value
  ad_admin_username            = local.ad_admin_username
  managed_disk                 = lookup(each.value, "disks", {})
  rsv_rg_name                  = azurerm_resource_group.prod.name
  recovery_vault_name          = azurerm_recovery_services_vault.this.name
  backup_policy_id             = each.value.backup_policy_id
  tags_customer                = local.customer_name
  tags_environment             = each.key
  tags_patching                = each.key
  tags_project                 = "11${local.customer_number}"
}

module "sql" {
  source                       = "github.com/OpalwaveSolutions/terraform-azure-windows-vm"
  for_each                     = local.sql
  computer_name                = "az${local.customer_number}sql01"
  resource_group_name          = azurerm_resource_group.prod.name
  location                     = "uk south"
  subnet_name                  = each.value.subnet_name
  subnet_id                    = each.value.subnet_id
  zone                         = each.value.zone
  size                         = each.value.size
  proximity_placement_group_id = each.value.proximity_placement_group_id
  source_image_id              = data.azurerm_image.server2016.id
  admin_username               = local.admin_username
  admin_password               = data.azurerm_key_vault_secret.local_admin_password.value
  active_directory_domain_name = local.customer_domain_name
  ad_admin_password            = data.azurerm_key_vault_secret.ad_admin_password.value
  ad_admin_username            = local.ad_admin_username
  managed_disk                 = lookup(each.value, "disks", {})
  rsv_rg_name                  = azurerm_resource_group.prod.name
  recovery_vault_name          = azurerm_recovery_services_vault.this.name
  backup_policy_id             = each.value.backup_policy_id
  tags_customer                = local.customer_name
  tags_environment             = each.key
  tags_patching                = each.key
  tags_project                 = "11${local.customer_number}"
}

module "vda" {
  source                       = "github.com/OpalwaveSolutions/terraform-azure-windows-vda?ref=v1.1.1"
  for_each                     = local.vda
  name                         = "az${local.customer_number}vda${each.key}template"
  computer_name                = "az${local.customer_number}vda${each.key}"
  resource_group_name          = azurerm_resource_group.prod.name
  location                     = azurerm_resource_group.prod.location
  subnet_name                  = data.azurerm_subnet.snet-presentation-prod.name
  subnet_id                    = data.azurerm_subnet.snet-presentation-prod.id
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
  tags_project                 = "11${local.customer_number}"
}
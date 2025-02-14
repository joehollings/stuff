# Recovery Services Vault
module "module_recovery_services_vaults" {
  source   = "../../azure/rm/azurerm_recovery_services_vault"
  for_each = local.customers

  name                = "rsv-${each.key}-${var.location}"
  location            = var.location
  resource_group_name = module.module_resource_groups_customers[each.key].resource_group.name
  soft_delete_enabled = each.value.rsv_soft_delete_enabled
  tags = {
    customer    = "${each.value.customer_name}",
    project     = "${each.key}",
    environment = "prod"
  }
}

module "module_dc_backup_policy" {
  source   = "./modules/dc_backup_policy"
  for_each = local.customers

  resource_group_name = module.module_resource_groups_customers[each.key].resource_group.name
  recovery_vault_name = module.module_recovery_services_vaults[each.key].recovery_services_vault.name
  dc01_id             = module.module_primary_dc[each.key].windows_virtual_machine.id
  dc02_id             = module.module_secondary_dc[each.key].windows_virtual_machine.id
}
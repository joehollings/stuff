resource "azurerm_backup_policy_vm" "this" {
  name                = "DomainControllers"
  resource_group_name = var.resource_group_name
  recovery_vault_name = var.recovery_vault_name

  backup {
    frequency = "Daily"
    time      = "23:00"
  }
  retention_daily {
    count = 10
  }
}

resource "azurerm_backup_protected_vm" "dc01" {
  resource_group_name = var.resource_group_name
  recovery_vault_name = var.recovery_vault_name
  source_vm_id        = var.dc01_id
  backup_policy_id    = azurerm_backup_policy_vm.this.id
}

resource "azurerm_backup_protected_vm" "dc02" {
  resource_group_name = var.resource_group_name
  recovery_vault_name = var.recovery_vault_name
  source_vm_id        = var.dc02_id
  backup_policy_id    = azurerm_backup_policy_vm.this.id
}
resource "azurerm_recovery_services_vault" "this" {
  name                = var.recovery_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
}

resource "azurerm_backup_policy_vm" "DailyVMBackup" {
  name                = "DailyVMBackup"
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.this.name

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "22:00"
  }

  retention_daily {
    count = 14
  }

  retention_weekly {
    count    = 12
    weekdays = ["Sunday"]
  }
}

resource "azurerm_backup_policy_vm" "WeeklyVMBackup" {
  name                           = "WeeklyVMBackup"
  resource_group_name            = var.resource_group_name
  recovery_vault_name            = azurerm_recovery_services_vault.this.name
  instant_restore_retention_days = "5"
  timezone                       = "UTC"

  backup {
    frequency = "Weekly"
    time      = "03:00"
    weekdays  = ["Sunday"]
  }

  retention_weekly {
    count    = 4
    weekdays = ["Sunday"]
  }
}

resource "azurerm_backup_protected_vm" "daily" {
  for_each            = var.daily_vm
  resource_group_name = azurerm_recovery_services_vault.this.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.this.name
  source_vm_id        = lookup(each.value, "id")
  backup_policy_id    = azurerm_backup_policy_vm.DailyVMBackup.id
}

resource "azurerm_backup_protected_vm" "weekly" {
  for_each            = var.weekly_vm
  resource_group_name = azurerm_recovery_services_vault.this.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.this.name
  source_vm_id        = lookup(each.value, "id")
  backup_policy_id    = azurerm_backup_policy_vm.WeeklyVMBackup.id
}
resource "azurerm_recovery_services_vault" "this" {
  name                = "rsv-10${local.customer_number}-prod"
  location            = azurerm_resource_group.prod.location
  resource_group_name = azurerm_resource_group.prod.name
  sku                 = "Standard"
  soft_delete_enabled = false

  tags = {
    customer    = local.customer_name
    environment = "prod"
    project     = "10${local.customer_number}"
  }
}

resource "azurerm_backup_policy_vm" "DailyVMBackup" {
  name                = "DailyVMBackup"
  resource_group_name = azurerm_resource_group.prod.name
  recovery_vault_name = azurerm_recovery_services_vault.this.name
  timezone            = "UTC"

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
  resource_group_name            = azurerm_resource_group.prod.name
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

resource "azurerm_backup_policy_file_share" "DailyDataBackup" {
  name                = "DailyDataBackup"
  resource_group_name = azurerm_resource_group.prod.name
  recovery_vault_name = azurerm_recovery_services_vault.this.name
  timezone            = "UTC"

  backup {
    frequency = "Daily"
    time      = "22:00"
  }

  retention_daily {
    count = 14
  }

  retention_weekly {
    count    = 4
    weekdays = ["Sunday"]
  }

  retention_monthly {
    count    = 4
    weekdays = ["Sunday"]
    weeks    = ["First"]
  }
}
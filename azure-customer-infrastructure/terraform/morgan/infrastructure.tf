resource "azurerm_resource_group" "prod" {
  name     = "10${local.customer_number}-rsg-prod"
  location = local.location

  tags = {
    customer    = local.customer_name
    environment = "prod"
    project     = "10${local.customer_number}"
  }
}

resource "azurerm_recovery_services_vault" "this" {
  name                = "rsv-10${local.customer_number}-prod"
  location            = azurerm_resource_group.prod.location
  resource_group_name = azurerm_resource_group.prod.name
  sku                 = "Standard"
  soft_delete_enabled = true

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

module "ppg" {
  source                         = "git@github.com:OpalwaveSolutions/terraform-azure-proximity-placement-group?ref=v1.0.0"
  for_each                       = local.proximity_placement_groups
  proximity_placement_group_name = each.value.name
  location                       = azurerm_resource_group.prod.location
  resource_group_name            = azurerm_resource_group.prod.name
}

module "dc_cc" {
  source              = "git@github.com:OpalwaveSolutions/terraform-azure-windows-dc-cc"
  for_each            = local.dc_cc
  computer_name       = each.value.computer_name
  resource_group_name = azurerm_resource_group.prod.name
  location            = azurerm_resource_group.prod.location
  subnet_name         = data.azurerm_subnet.snet-identityservices.name
  subnet_id           = data.azurerm_subnet.snet-identityservices.id
  zone                = each.value.zone
  size                = each.value.size
  source_image_id     = data.azurerm_image.dc_cc.id
  license_type        = each.value.license_type
  admin_username      = local.admin_username
  admin_password      = data.azurerm_key_vault_secret.local_admin_password.value
  rsv_rg_name         = azurerm_resource_group.prod.name
  recovery_vault_name = azurerm_recovery_services_vault.this.name
  backup_policy_id    = each.value.backup_policy_id
}

module "network" {
  source                      = "git@github.com:OpalwaveSolutions/terraform-azure-network"
  for_each                    = local.virtual_networks
  virtual_network_name        = "10${local.customer_number}-vnet-app-${each.key}"
  location                    = azurerm_resource_group.prod.location
  resource_group_name         = azurerm_resource_group.prod.name
  address_space               = each.value.address_space
  subnets                     = lookup(each.value, "subnets", {})
  remote_virtual_network_name = data.azurerm_virtual_network.vnet-hub.name
  remote_virtual_network_id   = data.azurerm_virtual_network.vnet-hub.id
  remote_resource_group_name  = data.azurerm_resource_group.hub-rsg-prod.name
  tags_customer               = local.customer_name
  tags_environment            = each.key
  tags_project                = "10${local.customer_number}"
}

module "storagefile" {
  source               = "git@github.com:OpalwaveSolutions/terraform-azure-storage-account"
  for_each             = local.storage_accounts_file
  storage_account_name = each.value.name
  resource_group_name  = azurerm_resource_group.prod.name
  location             = azurerm_resource_group.prod.location
  storage_sid          = each.value.storage_sid
  shares               = lookup(each.value, "shares", {})
  tags_customer        = local.customer_name
  tags_environment     = each.key
  tags_project         = "10${local.customer_number}"
}

module "storageblob" {
  source               = "git@github.com:OpalwaveSolutions/terraform-azure-storage-accountv2"
  for_each             = local.storage_accounts_blob
  storage_account_name = each.value.name
  resource_group_name  = azurerm_resource_group.prod.name
  location             = azurerm_resource_group.prod.location
  account_tier         = "Standard"
  account_kind         = "StorageV2"
  tags_customer        = local.customer_name
  tags_environment     = each.key
  tags_project         = "10${local.customer_number}"
}
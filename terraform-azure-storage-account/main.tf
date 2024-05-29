resource "azurerm_storage_account" "this" {
  name                            = var.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = var.account_tier
  account_kind                    = var.account_kind
  account_replication_type        = var.account_replication_type
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  azure_files_authentication {
    directory_type = "AD"
    active_directory {
      storage_sid         = var.storage_sid
      domain_name         = var.domain_name
      domain_sid          = var.domain_sid
      domain_guid         = var.domain_guid
      forest_name         = var.forest_name
      netbios_domain_name = var.netbios_domain_name
    }
  }

  tags = {
    Customer    = var.tags_customer
    environment = var.tags_environment
    Project     = var.tags_project
  }
}

resource "azurerm_backup_container_storage_account" "protection-container" {
  resource_group_name = var.resource_group_name
  recovery_vault_name = var.recovery_vault_name
  storage_account_id  = azurerm_storage_account.this.id
}


resource "azurerm_storage_share" "this" {
  for_each             = var.shares
  name                 = each.key
  storage_account_name = azurerm_storage_account.this.name
  quota                = each.value.quota
}


resource "azurerm_storage_account" "storage_account" {
  resource_group_name             = var.resource_group_name
  location                        = var.location
  name                            = var.name
  account_replication_type        = var.account_replication_type
  account_tier                    = var.account_tier
  account_kind                    = var.account_kind
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
  network_rules {
    default_action = "Deny"
    private_link_access {
      endpoint_resource_id = var.endpoint_resource_id
    }
  }
  tags = var.tags
}

output "storage_account" {
  value = azurerm_storage_account.storage_account
}

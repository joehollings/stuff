resource "azurerm_recovery_services_vault" "recovery_services_vault" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  soft_delete_enabled = var.soft_delete_enabled
  tags                = var.tags
}

output "recovery_services_vault" {
  value = azurerm_recovery_services_vault.recovery_services_vault
}
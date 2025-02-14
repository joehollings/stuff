resource "azurerm_virtual_desktop_application_group" "application_group" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  type          = var.type
  host_pool_id  = var.host_pool_id
  friendly_name = var.friendly_name
  description   = var.description
}
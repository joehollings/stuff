data "azurerm_virtual_network" "kab-hub-uksouth" {
  name                = "kab-hub-uksouth"
  resource_group_name = "kab-connectivity-uksouth"
}
# Create AVD workspace
resource "azurerm_virtual_desktop_workspace" "workspace" {
  name                = var.workspace
  resource_group_name = var.rg_name
  location            = var.location
  friendly_name       = var.workspace_friendlyname
  description         = var.workspace_description
}

# Create AVD DAG
resource "azurerm_virtual_desktop_application_group" "dag" {
  resource_group_name = var.rg_name
  location            = var.location
  host_pool_id        = azurerm_virtual_desktop_host_pool.hostpool.id

  type          = var.dag_type
  name          = var.dag_name
  friendly_name = var.dag_friendlyname
  description   = var.dag_description
  depends_on    = [azurerm_virtual_desktop_host_pool.hostpool, azurerm_virtual_desktop_workspace.workspace]
}

# Associate Workspace and DAG
resource "azurerm_virtual_desktop_workspace_application_group_association" "ws-dag" {
  application_group_id = azurerm_virtual_desktop_application_group.dag.id
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id
}
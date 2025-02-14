resource "azurerm_virtual_desktop_scaling_plan_host_pool_association" "scaling_plan_host_pool_association" {
  host_pool_id    = var.host_pool_id
  scaling_plan_id = var.scaling_plan_id
  enabled         = var.enabled
}
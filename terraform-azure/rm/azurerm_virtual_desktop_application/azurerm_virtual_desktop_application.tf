resource "azurerm_virtual_desktop_application" "application" {
  name                         = var.name
  application_group_id         = var.application_group_id
  friendly_name                = var.friendly_name
  description                  = var.description
  path                         = var.path
  command_line_argument_policy = var.command_line_argument_policy
  command_line_arguments       = var.command_line_arguments
  show_in_portal               = var.show_in_portal
  icon_path                    = var.path
  icon_index                   = var.icon_index
}
resource "azurerm_virtual_machine_extension" "post_deployment_configuration" {
  name                       = "Post-Deploy-Config"
  virtual_machine_id         = var.virtual_machine_id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  settings                   = <<SETTINGS
  {
    "commandToExecute": "powershell.exe -Command \"${var.powershell_command}\""
  }
SETTINGS

}
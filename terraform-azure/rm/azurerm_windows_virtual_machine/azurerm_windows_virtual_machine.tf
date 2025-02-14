resource "azurerm_windows_virtual_machine" "windows_virtual_machine" {
  name                         = var.name
  computer_name                = var.computer_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  zone                         = var.zone
  size                         = var.size
  admin_username               = var.admin_username
  admin_password               = var.admin_password
  availability_set_id          = var.availability_set_id
  proximity_placement_group_id = var.proximity_placement_group_id
  virtual_machine_scale_set_id = var.virtual_machine_scale_set_id
  tags                         = var.tags
  network_interface_ids        = var.network_interface_ids

  os_disk {
    name                 = var.os_disk_name
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.source_image_reference_publisher
    offer     = var.source_image_reference_offer
    sku       = var.source_image_reference_sku
    version   = var.source_image_reference_version
  }
}

resource "azurerm_managed_disk" "this" {
  for_each             = var.managed_disk
  name                 = join("", [var.computer_name, each.value.name])
  location             = azurerm_windows_virtual_machine.windows_virtual_machine.location
  resource_group_name  = azurerm_windows_virtual_machine.windows_virtual_machine.resource_group_name
  storage_account_type = lookup(each.value, "storage_account_type")
  create_option        = "Empty"
  disk_size_gb         = lookup(each.value, "size")
  zone                 = azurerm_windows_virtual_machine.windows_virtual_machine.zone
  tags                 = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "this" {
  for_each           = var.managed_disk
  managed_disk_id    = azurerm_managed_disk.this[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.windows_virtual_machine.id
  lun                = each.value.lun
  caching            = each.value.caching
}

output "windows_virtual_machine" {
  value = azurerm_windows_virtual_machine.windows_virtual_machine
}

# resource "azurerm_virtual_machine_extension" "WinRM" {
#   name                       = "Configure-WinRM"
#   virtual_machine_id         = azurerm_windows_virtual_machine.windows_virtual_machine.id
#   publisher                  = "Microsoft.Compute"
#   type                       = "CustomScriptExtension"
#   type_handler_version       = "1.0"
#   auto_upgrade_minor_version = true
#   settings                   = <<SETTINGS
#   {
#     "commandToExecute": "powershell.exe -Command \"${local.powershell_command}\""
#   }
# SETTINGS

# }

resource "azurerm_network_interface" "nic01" {
  name                          = "${var.computer_name}-nic001"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enable_accelerated_networking = var.enable_accelerated_networking

  ip_configuration {
    name                          = var.subnet_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
  }

  tags = {
    Application = var.tags_application
    Customer    = var.tags_customer
    environment = var.tags_environment
    Patching    = var.tags_patching
    Project     = var.tags_project
  }
}

resource "azurerm_windows_virtual_machine" "this" {
  name                         = var.computer_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  size                         = var.size
  zone                         = var.zone
  timezone                     = var.timezone
  admin_username               = var.admin_username
  admin_password               = var.admin_password
  license_type                 = var.license_type
  source_image_id              = var.source_image_id
  proximity_placement_group_id = var.proximity_placement_group_id
  network_interface_ids = [
    azurerm_network_interface.nic01.id,
  ]

  os_disk {
    name                 = "${var.computer_name}-os_disk"
    caching              = var.caching
    storage_account_type = var.storage_account_type
  }

  # source_image_reference {
  #   publisher = var.source_image_reference_publisher
  #   offer     = var.source_image_reference_offer
  #   sku       = var.source_image_reference_sku
  #   version   = var.source_image_reference_version
  # }

  tags = {
    Application = var.tags_application
    Customer    = var.tags_customer
    environment = var.tags_environment
    Project     = var.tags_project
  }
}

# Data Disks

resource "azurerm_managed_disk" "this" {
  for_each             = var.managed_disk
  name                 = join("", [var.computer_name, each.value.name])
  location             = azurerm_windows_virtual_machine.this.location
  resource_group_name  = azurerm_windows_virtual_machine.this.resource_group_name
  storage_account_type = lookup(each.value, "storage_account_type")
  create_option        = var.data_disk_create_option
  disk_size_gb         = lookup(each.value, "size")
  zone                 = azurerm_windows_virtual_machine.this.zone
  tags = {
    Application = var.tags_application
    Customer    = var.tags_customer
    environment = var.tags_environment
    Patching    = var.tags_patching
    Project     = var.tags_project
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "this" {
  for_each           = var.managed_disk
  managed_disk_id    = azurerm_managed_disk.this[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.this.id
  lun                = each.value.lun
  caching            = each.value.caching
}

resource "azurerm_backup_protected_vm" "this" {
  resource_group_name = var.rsv_rg_name
  recovery_vault_name = var.recovery_vault_name
  source_vm_id        = azurerm_windows_virtual_machine.this.id
  backup_policy_id    = var.backup_policy_id
}

resource "azurerm_virtual_machine_extension" "join-domain" {
  name                 = "join-domain"
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  virtual_machine_id   = azurerm_windows_virtual_machine.this.id

  settings = <<SETTINGS
    {
        "Name": "${var.active_directory_domain_name}",
        "OUPath": "",
        "User": "${var.ad_admin_username}@owscs.local",
        "Restart": "true",
        "Options": "3"
    }
SETTINGS

  protected_settings = <<SETTINGS
    {
        "Password": "${var.ad_admin_password}"
    }
SETTINGS  
}
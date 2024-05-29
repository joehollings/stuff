resource "azurerm_network_interface" "nic01" {
  name                          = "${var.name}-nic001"
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
  name                = var.name
  computer_name       = var.computer_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  zone                = var.zone
  timezone            = var.timezone
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  license_type        = var.license_type
  source_image_id     = var.source_image_id
  network_interface_ids = [
    azurerm_network_interface.nic01.id,
  ]

  os_disk {
    name                 = "${var.name}-os_disk"
    caching              = var.caching
    storage_account_type = var.storage_account_type
  }

  tags = {
    Application = var.tags_application
    Customer    = var.tags_customer
    environment = var.tags_environment
    Project     = var.tags_project
  }
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

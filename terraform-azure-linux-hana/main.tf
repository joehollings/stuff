resource "azurerm_network_interface" "nic" {
  name                          = "${var.computer_name}-nic-01"
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
    Project     = var.tags_project
  }
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "this" {
  name                         = var.computer_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  network_interface_ids        = [azurerm_network_interface.nic.id]
  proximity_placement_group_id = var.proximity_placement_group_id
  source_image_id              = var.source_image_id
  license_type                 = var.license_type
  size                         = var.size
  zone                         = var.zone

  os_disk {
    name                 = "${var.computer_name}-os_disk-01"
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  tags = {
    Application = var.tags_application
    Customer    = var.tags_customer
    environment = var.tags_environment
    Project     = var.tags_project
  }

  # source_image_reference {
  #   publisher = var.source_image_reference_publisher
  #   offer     = var.source_image_reference_offer
  #   sku       = var.source_image_reference_sku
  #   version   = var.source_image_reference_version
  # }

  computer_name                   = var.computer_name
  admin_username                  = var.admin_user
  admin_password                  = var.admin_password
  disable_password_authentication = var.disable_password_authentication
  custom_data = base64encode(templatefile("${path.module}/post_deploy.sh", {
    host_name      = var.computer_name
    hana_sid       = var.hana_sid
    install_script = var.install_script
    reg_code       = var.reg_code
  }))
}

# Data Disks

resource "azurerm_managed_disk" "this" {
  for_each             = var.managed_disk
  name                 = join("", [var.computer_name, each.value.name])
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = lookup(each.value, "storage_account_type")
  create_option        = var.data_disk_create_option
  disk_size_gb         = lookup(each.value, "size")
  zone                 = azurerm_linux_virtual_machine.this.zone

  tags = {
    Application = var.tags_application
    Customer    = var.tags_customer
    environment = var.tags_environment
    Project     = var.tags_project
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "this" {
  for_each           = var.managed_disk
  managed_disk_id    = azurerm_managed_disk.this[each.key].id
  virtual_machine_id = azurerm_linux_virtual_machine.this.id
  lun                = each.value.lun
  caching            = each.value.caching
}
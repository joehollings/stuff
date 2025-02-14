# Resource group for each customers domain controllers
module "module_resource_groups_customers" {
  source   = "../../azure/rm/azurerm_resource_group"
  for_each = local.customers

  name     = "${each.key}-identity-${var.location}"
  location = var.location
  tags = {
    customer    = "${each.value.customer_name}",
    project     = "${each.key}",
    environment = "prod"
  }
}
# NICs for Primary Domain Controllers
module "module_primary_dc_network_interfaces" {
  source   = "../../azure/rm/azurerm_network_interface"
  for_each = local.customers

  resource_group_name                   = module.module_resource_groups_customers[each.key].resource_group.name
  location                              = var.location
  name                                  = "az${each.key}dc01-nic-01"
  ip_configuration_name                 = "nic-01"
  ip_configuration_subnet_id            = module.module_subnets.subnet.id
  ip_configuration_public_ip_address_id = null
  tags = {
    customer    = "${each.value.customer_name}",
    project     = "${each.key}",
    environment = "prod"
  }
}
# Creates NICs for Secondary Domain Controllers
module "module_secondary_dc_network_interfaces" {
  source   = "../../azure/rm/azurerm_network_interface"
  for_each = local.customers

  resource_group_name                   = module.module_resource_groups_customers[each.key].resource_group.name
  location                              = var.location
  name                                  = "az${each.key}dc02-nic-01"
  ip_configuration_name                 = "nic-01"
  ip_configuration_subnet_id            = module.module_subnets.subnet.id
  ip_configuration_public_ip_address_id = null
  tags = {
    customer    = "${each.value.customer_name}",
    project     = "${each.key}",
    environment = "prod"
  }
}
# Domain Controller VMs
module "module_primary_dc" {
  source   = "../../azure/rm/azurerm_windows_virtual_machine"
  for_each = local.customers

  resource_group_name              = module.module_resource_groups_customers[each.key].resource_group.name
  location                         = var.location
  name                             = "az${each.key}dc01"
  computer_name                    = "az${each.key}dc01"
  size                             = "Standard_B2s"
  network_interface_ids            = [module.module_primary_dc_network_interfaces[each.key].network_interface.id]
  admin_username                   = var.admin_username
  admin_password                   = var.admin_password
  os_disk_name                     = "az${each.key}dc01-os-disk-01"
  source_image_reference_offer     = "WindowsServer"
  source_image_reference_publisher = "MicrosoftWindowsServer"
  source_image_reference_sku       = "2022-datacenter-azure-edition"
  source_image_reference_version   = "latest"
  tags = {
    customer    = "${each.value.customer_name}",
    project     = "${each.key}",
    environment = "prod"
  }
}
module "module_secondary_dc" {
  source   = "../../azure/rm/azurerm_windows_virtual_machine"
  for_each = local.customers

  resource_group_name              = module.module_resource_groups_customers[each.key].resource_group.name
  location                         = var.location
  name                             = "az${each.key}dc02"
  computer_name                    = "az${each.key}dc02"
  size                             = "Standard_B2s"
  network_interface_ids            = [module.module_secondary_dc_network_interfaces[each.key].network_interface.id]
  admin_username                   = var.admin_username
  admin_password                   = var.admin_password
  os_disk_name                     = "az${each.key}dc02-os-disk-01"
  source_image_reference_offer     = "WindowsServer"
  source_image_reference_publisher = "MicrosoftWindowsServer"
  source_image_reference_sku       = "2022-datacenter-azure-edition"
  source_image_reference_version   = "latest"
  tags = {
    customer    = "${each.value.customer_name}",
    project     = "${each.key}",
    environment = "prod"
  }
}
# Script extension to configure WinRM
module "module_primary_dc_winrm_script_extension" {
  source             = "../../azure/rm/azurerm_virtual_machine_extension"
  for_each           = local.customers
  virtual_machine_id = module.module_primary_dc[each.key].windows_virtual_machine.id
  powershell_command = local.powershell_command
}
module "module_secondary_dc_winrm_script_extension" {
  source             = "../../azure/rm/azurerm_virtual_machine_extension"
  for_each           = local.customers
  virtual_machine_id = module.module_secondary_dc[each.key].windows_virtual_machine.id
  powershell_command = local.powershell_command
}
# DNS Resolver rule for each AD domain 
module "module_private_dns_resolver_forwarding_rules_hub" {
  source                          = "../../azure/rm/azurerm_private_dns_resolver_forwarding_rule"
  for_each                        = local.customers
  name                            = each.key
  enabled                         = true
  domain_name                     = "${each.key}.local."
  dns_forwarding_ruleset_id       = var.kab-hub-uksouth
  dns_server_primary_ip_address   = module.module_primary_dc_network_interfaces[each.key].network_interface.private_ip_address
  dns_server_secondary_ip_address = module.module_secondary_dc_network_interfaces[each.key].network_interface.private_ip_address
}
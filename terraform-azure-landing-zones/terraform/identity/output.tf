output "identity_virtual_network_id" {
  value = module.module_virtual_networks.virtual_network.id
}

output "customer_number" {
  value = local.ip_output
}

output "root_primary_domain_controller" {
  value = module.module_network_interfaces_windows[local.root_ip_output].network_interface.name
}

output "root_secondary_domain_controller" {
  value = module.module_network_interfaces_windows[local.root_ip_output].network_interface.name
}

output "primary_domain_controller_ip" {
  value = module.module_primary_dc_network_interfaces[local.ip_output].network_interface.private_ip_address
}

output "secondary_domain_controller_ip" {
  value = module.module_secondary_dc_network_interfaces[local.ip_output].network_interface.private_ip_address
}

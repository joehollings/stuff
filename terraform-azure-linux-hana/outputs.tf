output "Hana_Hostname" {
  value = azurerm_linux_virtual_machine.this.computer_name
}

output "Hana_IP" {
  value = azurerm_linux_virtual_machine.this.private_ip_address
}
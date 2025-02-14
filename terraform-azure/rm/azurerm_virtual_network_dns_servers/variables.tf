variable "virtual_network_id" {
  description = "(Required) The ID of the Virtual Network that should be linked to the DNS Zone. Changing this forces a new resource to be created."
  type        = string
}

variable "dns_servers" {
  description = "(Optional) List of IP addresses of DNS servers."
  type        = list(string)
}
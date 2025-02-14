variable "name" {
  description = "(Required) Specifies the name which should be used for this Private DNS Resolver Inbound Endpoint. Changing this forces a new Private DNS Resolver Inbound Endpoint to be created."
  type        = string
}

variable "private_dns_resolver_id" {
  description = "(Required) Specifies the ID of the Private DNS Resolver Inbound Endpoint. Changing this forces a new Private DNS Resolver Inbound Endpoint to be created."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the Azure Region where the Private DNS Resolver Inbound Endpoint should exist. Changing this forces a new Private DNS Resolver Inbound Endpoint to be created."
  type        = string
}

variable "tags" {
  description = "(Optional) A mapping of tags which should be assigned to the Private DNS Resolver Inbound Endpoint."
  type        = map(string)
  default     = {}
}

variable "ip_configurations_private_ip_allocation_method" {
  description = "(Optional) Private IP address allocation method. Allowed value is Dynamic and Static. Defaults to Dynamic."
  type        = string
  default     = "Dynamic"
}

variable "private_ip_allocation_method_subnet_id" {
  description = "(Required) The subnet ID of the IP configuration."
  type        = string
}
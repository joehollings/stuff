variable "resource_group_name" {
  description = "(Required) The name of the Resource Group in which to create the Network Interface. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "(Required) The location where the Network Interface should exist. Changing this forces a new resource to be created."
  type        = string
}

variable "name" {
  description = "(Required) The name of the Network Interface. Changing this forces a new resource to be created."
  type        = string
}

variable "ip_forwarding_enabled" {
  description = " (Optional) Should IP Forwarding be enabled? Defaults to false."
  default     = false
  type        = bool
}

variable "accelerated_networking_enabled" {
  description = "(Optional) Should Accelerated Networking be enabled? Defaults to false."
  default     = false
  type        = bool
}

variable "ip_configuration_name" {
  description = "(Required) A name used for this IP Configuration."
  type        = string
}

variable "ip_configuration_subnet_id" {
  description = "(Optional) The ID of the Subnet where this Network Interface should be located in."
  type        = string
}

variable "ip_configuration_private_ip_address_allocation" {
  description = "(Required) The allocation method used for the Private IP Address. Possible values are Dynamic and Static."
  default     = "Dynamic"
  type        = string
}

variable "ip_configuration_private_ip_address" {
  description = "(Optional) The Static IP Address which should be used."
  default     = null
  type        = string
}

variable "ip_configuration_public_ip_address_id" {
  description = "(Optional) Reference to a Public IP Address to associate with this NIC"
  default     = null
  type        = string
}

variable "tags" {
  description = "tags"
  default     = null
}

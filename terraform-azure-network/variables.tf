variable "allow_gateway_transit" {
  type = string
  description = "(Optional) Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. Defaults to false."
  default = "True"
}

variable "location" {
  type        = string
  description = "Location of resources"
  default     = "UK South"
}

variable "resource_group_name" {
  type        = string
  description = "Name of Resource Group"
  default     = ""
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "address_space" {
  description = "IP address space for customer vNet"
  type        = list(string)
  default     = []
}

variable "dns_servers" {
  type        = list(string)
  description = "dns servers for customer vNet"
  default     = ["10.10.4.4", "10.10.4.5"]
}

variable "subnets" {
  type        = any
  description = "Map of subnets for each virtual network"
  default     = {}
}

variable "remote_resource_group_name" {
  type        = string
  description = "Name of Resource Group that contains the remote virtual network"
  default     = ""
}

variable "remote_virtual_network_name" {
  type        = string
  description = "Name of the remote virtual network"
}

variable "remote_virtual_network_id" {
  type        = string
  description = "ID of the remote virtual network"
  default     = ""
}

variable "network_security_group_name" {
  type        = string
  description = "Name of the network security group"
  default     = ""
}

variable "tags_customer" {
  type = string
}

variable "tags_environment" {
  type = string
}

variable "tags_project" {
  type = string
}
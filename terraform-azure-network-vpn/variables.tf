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

variable "subnets" {
  type        = any
  description = "Map of subnets for each virtual network"
  default     = {}
}

variable "vpn_name" {
  type        = string
  description = "Name of VPN Gateway"
}

variable "frontend_address_space" {
  description = "IP address space for customer VPN"
  type        = list(string)
  default     = []
}

variable "gatewaysubnet" {
  description = "IP Subnet for VPN"
  type        = list(string)
  default     = []
}

variable "gateway_address" {
  type        = string
  description = "(Optional) The gateway IP address to connect with."
}

variable "gateway_address_space" {
  description = "(Optional) The list of string CIDRs representing the address spaces the gateway exposes."
  type        = list(string)
  default     = []
}

variable "vpn_subnet_name" {
  type        = string
  description = "(Required) The name of the subnet. Changing this forces a new resource to be created."
  default     = ""
}

variable "lgw_name" {
  type        = string
  description = "(Required) The name of the local network gateway. Changing this forces a new resource to be created."
}

variable "pip_name" {
  type        = string
  description = "(Required) Specifies the name of the Public IP. Changing this forces a new Public IP to be created."
}

variable "vgw_name" {
  type        = string
  description = "(Required) The name of the Virtual Network Gateway. Changing this forces a new resource to be created."
}

variable "allocation_method" {
  type        = string
  description = " (Required) Defines the allocation method for this IP address. Possible values are Static or Dynamic."
  default     = "Dynamic"
}

variable "sku" {
  type        = string
  description = "(Required) Configuration of the size and capacity of the virtual network gateway. Valid options are Basic, Standard, HighPerformance, UltraPerformance, ErGw1AZ, ErGw2AZ, ErGw3AZ, VpnGw1, VpnGw2, VpnGw3, VpnGw4,VpnGw5, VpnGw1AZ, VpnGw2AZ, VpnGw3AZ,VpnGw4AZ and VpnGw5AZ and depend on the type, vpn_type and generation arguments. A PolicyBased gateway only supports the Basic SKU. Further, the UltraPerformance SKU is only supported by an ExpressRoute gateway."
  default     = "VpnGw1"
}

variable "type" {
  type        = string
  description = "(Required) The type of the Virtual Network Gateway. Valid options are Vpn or ExpressRoute. Changing the type forces a new resource to be created."
  default     = "Vpn"
}

variable "vpn_type" {
  type        = string
  description = "(Optional) The routing type of the Virtual Network Gateway. Valid options are RouteBased or PolicyBased. Defaults to RouteBased. Changing this forces a new resource to be created."
  default     = "RouteBased"
}

variable "private_ip_address_allocation" {
  type        = string
  description = "(Optional) Defines how the private IP address of the gateways virtual interface is assigned. Valid options are Static or Dynamic. Defaults to Dynamic."
  default     = "Dynamic"
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
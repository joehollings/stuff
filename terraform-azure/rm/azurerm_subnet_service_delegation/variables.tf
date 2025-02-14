variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the subnet. This must be the resource group that the virtual network resides in. Changing this forces a new resource to be created."
  type        = string
}

variable "name" {
  description = "(Required) The name of the subnet. Changing this forces a new resource to be created."
  type        = string
}

variable "vnet_name" {
  description = "(Required) The name of the virtual network to which to attach the subnet. Changing this forces a new resource to be created."
  type        = string
}

variable "address_prefixes" {
  description = "(Required) The address prefixes to use for the subnet."
  type        = list(string)
  default     = []
}

variable "delegation_name" {
  description = "(Required) A name for this delegation."
  type        = string
}

variable "service_delegation_name" {
  description = "(Required) The name of service to delegate to. "
  type        = string
}

variable "service_delegation_actions" {
  description = "(Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to."
  type        = list(string)
}

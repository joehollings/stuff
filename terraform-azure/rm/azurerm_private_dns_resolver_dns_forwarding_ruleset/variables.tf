variable "name" {
  description = "(Required) Specifies the name which should be used for this Private DNS Resolver. Changing this forces a new Private DNS Resolver to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) Specifies the name of the Resource Group where the Private DNS Resolver should exist. Changing this forces a new Private DNS Resolver to be created."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the Azure Region where the Private DNS Resolver should exist. Changing this forces a new Private DNS Resolver to be created."
  type        = string
}

variable "private_dns_resolver_outbound_endpoint_ids" {
  description = "(Required) The list of IDs of the Private DNS Resolver Outbound Endpoint that is linked to the Private DNS Resolver Dns Forwarding Ruleset."
  type        = list(string)
}

variable "tags" {
  description = "(Optional) A mapping of tags which should be assigned to the Private DNS Resolver."
  type        = map(string)
  default     = {}
}
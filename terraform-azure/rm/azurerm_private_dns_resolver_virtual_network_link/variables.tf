variable "name" {
  description = "(Required) Specifies the name which should be used for this Private DNS Resolver. Changing this forces a new Private DNS Resolver to be created."
  type        = string
}

variable "virtual_network_id" {
  description = "(Required) The ID of the Virtual Network that is linked to the Private DNS Resolver. Changing this forces a new Private DNS Resolver to be created."
  type        = string
}

variable "dns_forwarding_ruleset_id" {
  description = "(Required) Specifies the ID of the Private DNS Resolver DNS Forwarding Ruleset. Changing this forces a new Private DNS Resolver Virtual Network Link to be created."
  type        = string
}

variable "metadata" {
  description = "(Optional) Metadata attached to the Private DNS Resolver Virtual Network Link."
  type        = map(string)
  default     = null
}

variable "tags" {
  description = "(Optional) A mapping of tags which should be assigned to the Private DNS Resolver."
  type        = map(string)
  default     = {}
}
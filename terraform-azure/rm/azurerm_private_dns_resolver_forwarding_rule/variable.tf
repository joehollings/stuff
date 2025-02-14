variable "name" {
  description = "(Required) Specifies the name which should be used for this Private DNS Resolver. Changing this forces a new Private DNS Resolver to be created."
  type        = string
}

variable "dns_forwarding_ruleset_id" {
  description = "(Required) Specifies the ID of the Private DNS Resolver DNS Forwarding Ruleset. Changing this forces a new Private DNS Resolver Virtual Network Link to be created."
  type        = string
}

variable "domain_name" {
  description = "(Required) Specifies the domain name for the Private DNS Resolver Forwarding Rule. Changing this forces a new Private DNS Resolver Forwarding Rule to be created."
  type        = string
}

variable "dns_server_primary_ip_address" {
  description = "(Required) DNS server IP address."
  type        = string
}

variable "dns_server_secondary_ip_address" {
  description = "(Required) DNS server IP address."
  type        = string
}

variable "enabled" {
  description = "(Optional) Specifies the state of the Private DNS Resolver Forwarding Rule. Defaults to true."
  type        = bool
  default     = true
}

variable "metadata" {
  description = "(Optional) Metadata attached to the Private DNS Resolver Virtual Network Link."
  type        = map(string)
  default     = {}
}
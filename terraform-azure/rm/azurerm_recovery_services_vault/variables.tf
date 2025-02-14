variable "name" {
  description = "(Required) Specifies the name of the Recovery Services Vault. Recovery Service Vault name must be 2 - 50 characters long, start with a letter, contain only letters, numbers and hyphens. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = " (Required) The name of the resource group in which to create the Recovery Services Vault. Changing this forces a new resource to be created."
  type        = string
}

variable "sku" {
  description = "(Required) Sets the vault's SKU. Possible values include: Standard, RS0."
  type        = string
  default     = "Standard"
}

variable "soft_delete_enabled" {
  description = "(Optional) Is soft delete enable for this Vault? Defaults to true."
  type        = bool
  default     = false
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
}
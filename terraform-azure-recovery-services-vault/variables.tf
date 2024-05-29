variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Recovery Services Vault. Changing this forces a new resource to be created."
}

variable "recovery_vault_name" {
  type        = string
  description = "(Required) Specifies the name of the Recovery Services Vault to use. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = " (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "sku" {
  type        = string
  description = "(Required) Sets the vault's SKU. Possible values include: Standard, RS0."
  default     = "Standard"
}

variable "daily_vm" {
  type    = any
  default = {}
}

variable "weekly_vm" {
  type    = any
  default = {}
}
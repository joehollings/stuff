variable "resource_group_name" {
  description = "Name of Resource group containing the Recovery Services Vault."
  type = string
}

variable "recovery_vault_name" {
  description = "Name of Recovery Services Vault."
  type = string
}

variable "dc01_id" {
  description = "Virtual machine ID for Primary Domain Controller."
  type = string
}

variable "dc02_id" {
  description = "Virtual machine ID for Secondary Domain Controller."
  type = string
}
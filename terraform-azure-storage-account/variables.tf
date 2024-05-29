variable "location" {
  type        = string
  description = "Location of resources"
  default     = "UK South"
}

variable "storage_account_name" {
  type        = string
  description = "(Required) Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed. Changing this forces a new resource to be created. This must be unique across the entire Azure service, not just within the resource group."
  default     = ""
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the storage account. Changing this forces a new resource to be created."
  default     = ""
}

variable "account_tier" {
  type        = string
  description = "(Required) Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. Changing this forces a new resource to be created."
  default     = "Premium"
}

variable "account_kind" {
  type        = string
  description = "(Optional) Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Changing this forces a new resource to be created. Defaults to StorageV2."
  default     = "FileStorage"
}

variable "account_replication_type" {
  type        = string
  description = "(Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS. Changing this forces a new resource to be created when types LRS, GRS and RAGRS are changed to ZRS, GZRS or RAGZRS and vice versa."
  default     = "ZRS"
}

variable "allow_nested_items_to_be_public" {
  type        = bool
  description = "(Optional) Allow or disallow nested items within this Account to opt into being public. Defaults to true."
  default     = false
}

variable "storage_sid" {
  type        = string
  description = "(Required) Specifies the security identifier (SID) for Azure Storage."
  default     = ""
}

variable "domain_name" {
  type        = string
  description = "(Required) Specifies the primary domain that the AD DNS server is authoritative for."
  default     = "OWSCS.local"
}

variable "domain_sid" {
  type        = string
  description = "(Required) Specifies the security identifier (SID)."
  default     = "S-1-5-21-2079600466-3062766412-2793361815"
}

variable "domain_guid" {
  type        = string
  description = "(Required) Specifies the domain GUID."
  default     = "8a1dbcf1-fefd-437d-a3b3-9d45a6fb1d7c"
}

variable "forest_name" {
  type        = string
  description = "(Required) Specifies the Active Directory forest."
  default     = "OWSCS.local"
}

variable "netbios_domain_name" {
  type        = string
  description = "(Required) Specifies the NetBIOS domain name."
  default     = "OWSCS.local"
}

variable "recovery_vault_name" {
  description = "(Required) The name of the vault where the storage account will be registered. Changing this forces a new resource to be created."
  type        = string
  default     = ""

}

variable "shares" {
  description = "File shares to be created in the Storage account"
  type        = any
  default     = {}
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
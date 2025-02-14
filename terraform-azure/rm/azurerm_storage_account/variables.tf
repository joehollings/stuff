variable "resource_group_name" {
  description = "resource_group_name"
  type        = string
}

variable "location" {
  description = "location"
  type        = string
}

variable "name" {
  description = "name"
  type        = string
}

variable "account_replication_type" {
  description = "(Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS. Changing this forces a new resource to be created when types LRS, GRS and RAGRS are changed to ZRS, GZRS or RAGZRS and vice versa."
  type        = string
  default     = "ZRS"
}

variable "account_tier" {
  description = "(Optional) Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot."
  type        = string
}

variable "account_kind" {
  description = "(Optional) Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Defaults to StorageV2"
  type        = string
  default     = "FileStorage"
}

variable "allow_nested_items_to_be_public" {
  description = "(Optional) Allow or disallow nested items within this Account to opt into being public. Defaults to true."
  type        = bool
  default     = false
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = null
}

variable "storage_sid" {
  description = " (Optional) Specifies the security identifier (SID) for Azure Storage. This is required when directory_type is set to AD."
  type        = string
}

variable "domain_name" {
  description = "(Required) Specifies the primary domain that the AD DNS server is authoritative for."
  type        = string
}

variable "domain_sid" {
  description = "(Optional) Specifies the security identifier (SID). This is required when directory_type is set to AD."
  type        = string
}

variable "domain_guid" {
  description = " (Required) Specifies the domain GUID."
  type        = string
}

variable "forest_name" {
  description = "(Optional) Specifies the Active Directory forest. This is required when directory_type is set to AD."
  type        = string
}

variable "netbios_domain_name" {
  description = "(Optional) Specifies the NetBIOS domain name. This is required when directory_type is set to AD."
  type        = string
}

variable "endpoint_resource_id" {
  description = "(Required) The ID of the Azure resource that should be allowed access to the target storage account."
  type        = string

}
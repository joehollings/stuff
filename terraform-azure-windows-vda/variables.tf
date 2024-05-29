variable "active_directory_domain_name" {
  description = "Name of Active Directory Domain to join"
  type        = string
  default     = ""
}

variable "ad_admin_password" {
  description = "Key Vault Secrete value containing password for Domain admin user"
  type        = string
  default     = ""
}

variable "ad_admin_username" {
  description = "Domain administrator account to use for domain join"
  type        = string
  default     = ""
}

variable "admin_password" {
  description = "The Password which should be used for the local-administrator on this Virtual Machine. Changing this forces a new resource to be created."
  type        = string
}

variable "admin_username" {
  description = "The username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created."
  type        = string
  default     = ""
}

variable "caching" {
  description = "The Type of Caching which should be used for the Internal OS Disk. Possible values are None, ReadOnly and ReadWrite."
  type        = string
  default     = "ReadWrite"
}

variable "computer_name" {
  description = " (Optional) Specifies the Hostname which should be used for this Virtual Machine. If unspecified this defaults to the value for the name field. If the value of the name field is not a valid computer_name, then you must specify computer_name. Changing this forces a new resource to be created."
  type        = string
  default     = ""
}

variable "enable_accelerated_networking" {
  description = "Should Accelerated Networking be enabled?"
  type        = bool
  default     = false
}

variable "license_type" {
  description = "Specifies the type of on-premise license (also known as Azure Hybrid Use Benefit) which should be used for this Virtual Machine. Possible values are None, Windows_Client and Windows_Server."
  type        = string
  default     = "Windows_Client"
}

variable "location" {
  description = "The Azure location where the Windows Virtual Machine should exist. Changing this forces a new resource to be created."
  type        = string
  default     = "uksouth"
}

variable "name" {
  description = "(Required) The name of the Windows Virtual Machine. Changing this forces a new resource to be created."
  type        = string
  default     = ""
}

variable "os_disk_caching" {
  description = "The Type of Caching which should be used for the Internal OS Disk"
  type        = string
  default     = "ReadWrite"
}

variable "os_disk_name" {
  description = "The name which should be used for the Internal OS Disk"
  type        = string
  default     = ""
}

variable "os_disk_storage_account_type" {
  description = "The Type of Storage Account which should back this the Internal OS Disk"
  type        = string
  default     = "Premium_LRS"
}

variable "private_ip_address_allocation" {
  description = "private_ip_address_allocation"
  type        = string
  default     = "Dynamic"
}

variable "resource_group_name" {
  description = "The name of the Resource Group in which the Windows Virtual Machine should be exist. Changing this forces a new resource to be created."
  type        = string
  default     = ""
}

variable "size" {
  description = "The SKU which should be used for this Virtual Machine, such as Standard_F2"
  type        = string
  default     = "Standard_D2_v5"
}

variable "source_image_id" {
  description = "(Optional) The ID of the Image which this Virtual Machine should be created from. Changing this forces a new resource to be created. Possible Image ID types include Image IDs, Shared Image IDs, Shared Image Version IDs, Community Gallery Image IDs, Community Gallery Image Version IDs, Shared Gallery Image IDs and Shared Gallery Image Version IDs."
  type        = string
  default     = ""
}

variable "storage_account_type" {
  description = "The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard_LRS, StandardSSD_LRS, Premium_LRS, StandardSSD_ZRS and Premium_ZRS. Changing this forces a new resource to be created."
  type        = string
  default     = "Premium_LRS"
}

variable "subnet_id" {
  description = "The ID of the Subnet where this Network Interface should be located in."
  type        = string
  default     = ""
}

variable "subnet_name" {
  description = "The name of the Subnet where this Network Interface should be located in."
  type        = string
  default     = ""
}

variable "tags_application" {
  type    = string
  default = "Citrix"
}

variable "tags_customer" {
  type = string
}

variable "tags_environment" {
  type = string
}

variable "tags_patching" {
  type = string
}

variable "tags_project" {
  type = string
}

variable "timezone" {
  description = "Specifies the Time Zone which should be used by the Virtual Machine. Changing this forces a new resource to be created."
  type        = string
  default     = "GMT Standard Time"
}

variable "zone" {
  description = "Specifies the Availability Zones in which this Windows Virtual Machine should be located"
  type        = string
  default     = ""
}
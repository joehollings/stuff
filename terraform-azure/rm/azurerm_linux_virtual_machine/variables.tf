variable "resource_group_name" {
  description = "(Required) The name of the Resource Group in which the Linux Virtual Machine should be exist. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = " (Required) The Azure location where the Linux Virtual Machine should exist. Changing this forces a new resource to be created."
  type        = string
}

variable "name" {
  description = "(Required) The name of the Linux Virtual Machine. Changing this forces a new resource to be created."
  type        = string
}

variable "size" {
  description = "(Required) The SKU which should be used for this Virtual Machine, such as Standard_F2."
  default     = "Standard_B2s"
  type        = string
}

variable "availability_set_id" {
  description = "(Optional) Specifies the ID of the Availability Set in which the Virtual Machine should exist. Changing this forces a new resource to be created."
  default     = null
  type        = string
}

variable "network_interface_ids" {
  description = "(Required). A list of Network Interface IDs which should be attached to this Virtual Machine. The first Network Interface ID in this list will be the Primary Network Interface on the Virtual Machine."
  type        = list(string)
}

variable "admin_username" {
  description = " (Required) The username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created."
  sensitive   = true
  type        = string
}

variable "admin_password" {
  description = " (Optional) The Password which should be used for the local-administrator on this Virtual Machine. Changing this forces a new resource to be created."
  sensitive   = true
  type        = string
}

variable "computer_name" {
  description = " (Optional) Specifies the Hostname which should be used for this Virtual Machine. If unspecified this defaults to the value for the name field. If the value of the name field is not a valid computer_name, then you must specify computer_name. Changing this forces a new resource to be created."
  type        = string
}

variable "disable_password_authentication" {
  description = "(Optional) Should Password Authentication be disabled on this Virtual Machine? Defaults to true. Changing this forces a new resource to be created."
  default     = false
  type        = bool
}

variable "os_disk_name" {
  description = "(Optional) The name which should be used for the Internal OS Disk. Changing this forces a new resource to be created."
  type        = string
}

variable "os_disk_caching" {
  description = "(Required) The Type of Caching which should be used for the Internal OS Disk. Possible values are None, ReadOnly and ReadWrite."
  default     = "ReadWrite"
  type        = string
}

variable "os_disk_storage_account_type" {
  description = "(Required) The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard_LRS, StandardSSD_LRS, Premium_LRS, StandardSSD_ZRS and Premium_ZRS. Changing this forces a new resource to be created."
  default     = "Premium_LRS"
  type        = string
}

variable "allow_extension_operations" {
  description = "(Optional) Should Extension Operations be allowed on this Virtual Machine? Defaults to true."
  default     = true
  type        = bool
}

# variable "identity" {
#   description = "identity"
# }

variable "source_image_reference_publisher" {
  description = "(Required) Specifies the publisher of the image used to create the virtual machines. Changing this forces a new resource to be created."
  type        = string
}

variable "source_image_reference_offer" {
  description = "(Required) Specifies the offer of the image used to create the virtual machines. Changing this forces a new resource to be created."
  type        = string
}

variable "source_image_reference_sku" {
  description = "(Required) Specifies the SKU of the image used to create the virtual machines. Changing this forces a new resource to be created."
  type        = string
}

variable "source_image_reference_version" {
  description = "(Required) Specifies the version of the image used to create the virtual machines. Changing this forces a new resource to be created."
  type        = string
}

variable "zone" {
  description = "(Optional) Specifies the Availability Zones in which this Linux Virtual Machine should be located. Changing this forces a new Linux Virtual Machine to be created."
  default     = null
  type        = string
}

variable "tags" {
  description = "(Optional) A mapping of tags which should be assigned to this Virtual Machine."
  default     = null
  type        = map(string)
}

variable "location" {
  description = "The Azure location where the Linux Virtual Machine should exist"
  type        = string
  default     = "uksouth"
}

variable "resource_group_name" {
  description = "The name of the Resource Group in which the Linux Virtual Machine should be exist"
  type        = string
  default     = ""
}

variable "computer_name" {
  description = "Virtual machine name and hostname"
  type        = string
  default     = ""
}

variable "subnet_name" {
  description = "The name of the Network Interface"
  type        = string
  default     = ""
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "subnet_id" {
  description = "The name of the Network Interface"
  type        = string
  default     = ""
}

variable "private_ip_address_allocation" {
  description = "private_ip_address_allocation"
  type        = string
  default     = "Dynamic"
}

variable "enable_accelerated_networking" {
  description = "Should Accelerated Networking be enabled?"
  type        = bool
  default     = false
}

variable "proximity_placement_group" {
  description = "Name of the Proximity Placement Group"
  type        = string
  default     = ""
}

variable "size" {
  description = "The SKU which should be used for this Virtual Machine, such as Standard_F2"
  type        = string
  default     = "Standard_D8ds_v4"
}

variable "zone" {
  description = "Specifies the Availability Zones in which this Linux Virtual Machine should be located"
  type        = string
  default     = ""
}

variable "os_disk_name" {
  description = "The name which should be used for the Internal OS Disk"
  type        = string
  default     = ""
}

variable "os_disk_caching" {
  description = "The Type of Caching which should be used for the Internal OS Disk"
  type        = string
  default     = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  description = "The Type of Storage Account which should back this the Internal OS Disk"
  type        = string
  default     = "Premium_LRS"
}

variable "source_image_reference_publisher" {
  description = "Specifies the publisher of the image used to create the virtual machines"
  type        = string
  default     = "SUSE"
}

variable "source_image_reference_offer" {
  description = "Specifies the offer of the image used to create the virtual machines"
  type        = string
  default     = "sles-15-sp3-byos"
}

variable "source_image_reference_sku" {
  description = "Specifies the SKU of the image used to create the virtual machines"
  type        = string
  default     = "gen2"
}

variable "source_image_reference_version" {
  description = "Specifies the version of the image used to create the virtual machines"
  type        = string
  default     = "latest"
}

variable "admin_username" {
  description = "The username of the local administrator used for the Virtual Machine"
  type        = string
  default     = ""
}

variable "admin_password" {
  description = "The Password which should be used for the local-administrator on this Virtual Machine"
  type        = string
}

variable "disable_password_authentication" {
  description = "Should Password Authentication be disabled on this Virtual Machine?"
  type        = bool
  default     = false
}

variable "hana_id" {
  description = "SAP HANA system number"
  type        = string
  default     = "03"
}

variable "hana_sid" {
  description = "SAP HANA system ID or instance name for you SQL peeps"
  type        = string
  default     = ""
}

variable "managed_disk" {
  description = "Map of managed disks to create and attach to VM"
  type        = any
  default     = {}
}

variable "data_disk_create_option" {
  description = "The method to use when creating the managed disk"
  type        = string
  default     = "Empty"
}

variable "install_script" {
  description = "Name of HANA install script to use"
  type        = string
  default     = ""
}

variable "github_token" {
  description = "Github runner token"
  type        = string
  default     = "token"
}
variable "admin_password" {
  description = "The Password which should be used for the local-administrator on this Virtual Machine"
  type        = string
}

variable "admin_user" {
  description = "The username of the local administrator used for the Virtual Machine"
  type        = string
  default     = ""
}

variable "computer_name" {
  description = "Virtual machine name and hostname"
  type        = string
  default     = ""
}

variable "data_disk_create_option" {
  description = "The method to use when creating the managed disk"
  type        = string
  default     = "Empty"
}

variable "disable_password_authentication" {
  description = "Should Password Authentication be disabled on this Virtual Machine?"
  type        = bool
  default     = false
}

variable "enable_accelerated_networking" {
  description = "Should Accelerated Networking be enabled?"
  type        = bool
  default     = true
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

variable "install_script" {
  description = "Name of install script to use for HANA install"
  type        = string
  default     = "hana_install.sh"
}

variable "license_type" {
  description = "Specifies the BYOL Type for this Virtual Machine. Possible values are RHEL_BYOS and SLES_BYOS."
  type        = string
  default     = "SLES_BYOS"
}

variable "location" {
  description = "The Azure location where the Linux Virtual Machine should exist"
  type        = string
  default     = "uksouth"
}

variable "managed_disk" {
  description = "Map of managed disks to create and attach to VM"
  type        = any
  default     = {}
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

variable "proximity_placement_group_id" {
  description = "ID of the Proximity Placement Group"
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "The name of the Resource Group in which the Linux Virtual Machine should be exist"
  type        = string
  default     = ""
}

variable "size" {
  description = "The SKU which should be used for this Virtual Machine, such as Standard_F2"
  type        = string
  default     = ""
}

variable "reg_code" {
  description = "SUSE registration key"
  type        = string
  default     = ""
}

variable "source_image_id" {
  description = "The ID of the Image which this Virtual Machine should be created from. Changing this forces a new resource to be created. Possible Image ID types include Image IDs, Shared Image IDs, Shared Image Version IDs, Community Gallery Image IDs, Community Gallery Image Version IDs, Shared Gallery Image IDs and Shared Gallery Image Version IDs"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = " The ID of the Subnet where this Network Interface should be located in"
  type        = string
  default     = ""
}

variable "subnet_name" {
  description = "A name used for this IP Configuration"
  type        = string
  default     = ""
}

variable "tags_application" {
  type    = string
  default = "SAP"
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

variable "zone" {
  description = "Specifies the Availability Zones in which this Linux Virtual Machine should be located"
  type        = string
  default     = ""
}

# variable "source_image_reference_offer" {
#   description = "Specifies the offer of the image used to create the virtual machines"
#   type        = string
#   default     = "sles-15-sp1-byos"
# }



# variable "source_image_reference_publisher" {
#   description = "Specifies the publisher of the image used to create the virtual machines"
#   type        = string
#   default     = "SUSE"
# }


# variable "source_image_reference_sku" {
#   description = "Specifies the SKU of the image used to create the virtual machines"
#   type        = string
#   default     = "gen2"
# }

# variable "source_image_reference_version" {
#   description = "Specifies the version of the image used to create the virtual machines"
#   type        = string
#   default     = "latest"
# }
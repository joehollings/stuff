variable "admin_password" {
  description = "(Required) The Password which should be used for the local-administrator on this Virtual Machine. Changing this forces a new resource to be created."
  type        = string
  sensitive   = true
}

variable "admin_username" {
  description = "(Required) The username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created."
  type        = string
  sensitive   = true
}

variable "availability_set_id" {
  description = "(Optional) Specifies the ID of the Availability Set in which the Virtual Machine should exist. Changing this forces a new resource to be created."
  default     = null
  type        = string
}

variable "location" {
  description = "(Required) The Azure location where the Windows Virtual Machine should exist. Changing this forces a new resource to be created."
  type        = string
}

variable "zone" {
  description = "(Optional) Specifies the Availability Zones in which this Windows Virtual Machine should be located"
  type        = string
  default     = null
}

variable "name" {
  description = " (Required) The name of the Windows Virtual Machine. Changing this forces a new resource to be created."
  type        = string
}

variable "computer_name" {
  description = "(Optional) Specifies the Hostname which should be used for this Virtual Machine. If unspecified this defaults to the value for the name field. If the value of the name field is not a valid computer_name, then you must specify computer_name. Changing this forces a new resource to be created."
  type        = string
}

variable "proximity_placement_group_id" {
  description = "(Optional) The ID of the Proximity Placement Group which the Virtual Machine should be assigned to."
  default     = null
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group in which the Windows Virtual Machine should be exist. Changing this forces a new resource to be created."
  type        = string
}

variable "size" {
  description = "(Required) The SKU which should be used for this Virtual Machine, such as Standard_F2."
  default     = "Standard_B2s"
  type        = string
}

variable "network_interface_ids" {
  description = "(Required). A list of Network Interface IDs which should be attached to this Virtual Machine. The first Network Interface ID in this list will be the Primary Network Interface on the Virtual Machine."
  type        = list(string)
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
  default     = "Standard_LRS"
  type        = string
}

variable "virtual_machine_scale_set_id" {
  description = "(Optional) Specifies the Orchestrated Virtual Machine Scale Set that this Virtual Machine should be created within."
  default     = null
  type        = string
}

variable "source_image_reference_publisher" {
  description = "(Required) Specifies the publisher of the image used to create the virtual machines. Changing this forces a new resource to be created."
  default     = "MicrosoftWindowsServer"
  type        = string
}

variable "source_image_reference_offer" {
  description = "(Required) Specifies the offer of the image used to create the virtual machines. Changing this forces a new resource to be created."
  default     = "WindowsServer"
  type        = string
}

variable "source_image_reference_sku" {
  description = "(Required) Specifies the SKU of the image used to create the virtual machines. Changing this forces a new resource to be created."
  default     = "2022-datacenter-azure-edition"
  type        = string
}

variable "source_image_reference_version" {
  description = "(Required) Specifies the version of the image used to create the virtual machines. Changing this forces a new resource to be created."
  default     = "latest"
  type        = string
}

variable "tags" {
  description = "(Optional) A mapping of tags which should be assigned to this Virtual Machine."
  default     = null
  type        = map(string)
}

variable "managed_disk" {
  description = "Map of managed disks to create and attach to VM"
  type        = map(string)
  default     = {}
}

# locals {
#   backslash          = "$backslash = [char]0x05C"
#   command01          = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12"
#   url                = "$url = 'https://raw.githubusercontent.com/ansible/ansible-documentation/devel/examples/scripts/ConfigureRemotingForAnsible.ps1'"
#   file               = "$file = $env:temp + $backslash + 'ConfigureRemotingForAnsible.ps1'"
#   command02          = "(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)"
#   command03          = "powershell.exe -ExecutionPolicy ByPass -File $file"
#   powershell_command = "${local.backslash}; ${local.command01}; ${local.url}; ${local.file}; ${local.command02}; ${local.command03}"
# }
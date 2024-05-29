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

variable "location" {
  description = "The Azure location where the Windows Virtual Machine should exist. Changing this forces a new resource to be created."
  type        = string
  default     = "uksouth"
}

variable "resource_group_name" {
  description = "The name of the Resource Group in which the Windows Virtual Machine should be exist. Changing this forces a new resource to be created."
  type        = string
  default     = ""
}

variable "computer_name" {
  description = "Specifies the Hostname which should be used for this Virtual Machine. If unspecified this defaults to the value for the name field. If the value of the name field is not a valid computer_name, then you must specify computer_name. Changing this forces a new resource to be created."
  type        = string
  default     = ""
}

variable "subnet_name" {
  description = "The name of the Subnet where this Network Interface should be located in."
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "The ID of the Subnet where this Network Interface should be located in."
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
  default     = true
}

variable "size" {
  description = "The SKU which should be used for this Virtual Machine, such as Standard_F2"
  type        = string
  default     = "Standard_D8ds_v4"
}

variable "zone" {
  description = "Specifies the Availability Zones in which this Windows Virtual Machine should be located"
  type        = string
  default     = ""
}

variable "proximity_placement_group_id" {
  description = "ID of the Proximity Placement Group"
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

variable "source_image_id" {
  description = "(Optional) The ID of the Image which this Virtual Machine should be created from. Changing this forces a new resource to be created. Possible Image ID types include Image IDs, Shared Image IDs, Shared Image Version IDs, Community Gallery Image IDs, Community Gallery Image Version IDs, Shared Gallery Image IDs and Shared Gallery Image Version IDs."
  type        = string
  default     = ""
}

variable "source_image_reference_publisher" {
  description = "Specifies the publisher of the image used to create the virtual machines"
  type        = string
  default     = "MicrosoftWindowsServer"
}

variable "source_image_reference_offer" {
  description = "Specifies the offer of the image used to create the virtual machines"
  type        = string
  default     = "WindowsServer"
}

variable "source_image_reference_sku" {
  description = "Specifies the SKU of the image used to create the virtual machines"
  type        = string
  default     = "2019-Datacenter-gensecond"
}

variable "source_image_reference_version" {
  description = "Specifies the version of the image used to create the virtual machines"
  type        = string
  default     = "latest"
}

variable "admin_username" {
  description = "The username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created."
  type        = string
  default     = ""
}

variable "admin_password" {
  description = "The Password which should be used for the local-administrator on this Virtual Machine. Changing this forces a new resource to be created."
  type        = string
}

variable "timezone" {
  description = "Specifies the Time Zone which should be used by the Virtual Machine. Changing this forces a new resource to be created."
  type        = string
  default     = "GMT Standard Time"
}

variable "license_type" {
  description = "Specifies the type of on-premise license (also known as Azure Hybrid Use Benefit) which should be used for this Virtual Machine. Possible values are None, Windows_Client and Windows_Server."
  type        = string
  default     = "Windows_Server"
}

variable "caching" {
  description = "The Type of Caching which should be used for the Internal OS Disk. Possible values are None, ReadOnly and ReadWrite."
  type        = string
  default     = "ReadWrite"
}

variable "storage_account_type" {
  description = "The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard_LRS, StandardSSD_LRS, Premium_LRS, StandardSSD_ZRS and Premium_ZRS. Changing this forces a new resource to be created."
  type        = string
  default     = "Premium_LRS"
}

variable "data_disk" {
  type        = bool
  description = "Whether to create data disks or not"
  default     = false
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

variable "rsv_rg_name" {
  description = "Name of resource group containing RSV"
  type        = string
  default     = ""
}

variable "recovery_vault_name" {
  description = "Name of RSV"
  type        = string
  default     = ""
}

variable "backup_policy_id" {
  description = "ID of backup policy"
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

variable "tags_patching" {
  type = string
}

variable "tags_project" {
  type = string
}

locals {
  backslash = "$backslash = [char]0x05C"
  pagefile = "$pagefile = 'p:' + $backslash + 'pagefile.sys'"
  command01 = "Get-Disk | Where-Object OperationalStatus -EQ 'offline' | Set-Disk -IsOffline $false"
  command02 = "Get-Disk | Where-Object Size -LT '100000000000' | Where-Object PartitionStyle -EQ RAW | Initialize-Disk -PartitionStyle GPT -PassThru -Confirm:$false | New-Partition -DriveLetter P -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel 'Page' -Confirm:$false"
  command03 = "Get-Disk | Where-Object PartitionStyle -EQ RAW  | Initialize-Disk -PartitionStyle GPT -PassThru -Confirm:$false | New-Partition -DriveLetter S -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel 'Data' -Confirm:$false"
  command04 = "Set-Volume -DriveLetter C -NewFileSystemLabel 'System'"
  command05 = "Set-WmiInstance -Class Win32_PageFileSetting -Arguments @{name=$pagefile; InitialSize = 0; MaximumSize = 0} -EnableAllPrivileges | Out-Null"
  command06 = "$pagefileset = Get-WmiObject win32_pagefilesetting | Where-Object{$_.caption -like 'P:*'}"
  command07 = "$pagefileset.InitialSize = 51200"
  command08 = "$pagefileset.MaximumSize = 51200"
  command09 = "$pagefileset.Put()"
  command10 = "Set-Culture en-GB"
  command11 = "Set-WinSystemLocale -SystemLocale en-GB"
  command12 = "Set-WinUILanguageOverride -Language en-GB"
  command13 = "Set-WinUserLanguageList en-GB -Force"
  command14 = "Set-WinHomeLocation -GeoId 0xF2"
  powershell_command = "${local.backslash}; ${local.pagefile}; ${local.command01}; ${local.command02}; ${local.command03}; ${local.command04}; ${local.command05}; ${local.command06}; ${local.command07}; ${local.command08}; ${local.command09}; ${local.command10}; ${local.command11}; ${local.command12}; ${local.command13}; ${local.command14}"
}
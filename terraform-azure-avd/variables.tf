variable "rg_name" {
  type        = string
  default     = "rg-avd-resources"
  description = "Name of the Resource group in which to deploy service objects"
}

variable "location" {
  description = ""
  type        = string
}

variable "workspace" {
  type        = string
  description = "Name of the Azure Virtual Desktop workspace"
  default     = "AVD TF Workspace"
}

variable "workspace_description" {
  type = string
  description = "Description of the Azure Virtual Desktop workspace"
}

variable "workspace_friendlyname" {
  type = string
  description = "Friendly name of the Azure Virtual Desktop workspace"
}

variable "dag_type" {
  type = string
  description = "(Required) Type of Virtual Desktop Application Group. Valid options are RemoteApp or Desktop application groups. Changing this forces a new resource to be created."
  default = "Desktop"
}

variable "dag_name" {
  type = string
  description = "(Required) The name of the Virtual Desktop Application Group. Changing the name forces a new resource to be created."
  default = "${var.prefix}-dag"
}

variable "dag_friendlyname" {
  type = string
  description = "(Optional) Option to set a friendly name for the Virtual Desktop Application Group."
}

variable "dag_description" {
  type = string
  description = "(Optional) Option to set a description for the Virtual Desktop Application Group."
}

variable "hostpool" {
  type        = string
  description = "Name of the Azure Virtual Desktop host pool"
  default     = "AVD-TF-HP"
}

variable "host_pool_description" {
  description = "Host Pool description"
  type        = string
}

variable "rfc3339" {
  type        = string
  default     = "2024-05-23T12:00:00Z"
  description = "Registration token expiration"
}

variable "rdsh_count" {
  description = "Number of AVD machines to deploy"
  default     = 2
}

variable "session_host_subnet_id" {
  type        = string
  description = "The ID of the Subnet where the Session Host Network Interface should be located in"
}

variable "license_type" {
  type        = string
  description = "(Optional) Specifies the type of on-premise license (also known as Azure Hybrid Use Benefit) which should be used for this Virtual Machine. Possible values are None, Windows_Client and Windows_Server"
  default     = "Windows_Client"
}

variable "storage_account_type" {
  type        = string
  description = "(Required) The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard_LRS, StandardSSD_LRS, Premium_LRS, StandardSSD_ZRS and Premium_ZRS. Changing this forces a new resource to be created."
  default     = "Premium_ZRS"
}

variable "source_image_id" {
  type        = string
  description = "(Optional) The ID of the Image which this Virtual Machine should be created from. Changing this forces a new resource to be created. Possible Image ID types include Image IDs, Shared Image IDs, Shared Image Version IDs, Community Gallery Image IDs, Community Gallery Image Version IDs, Shared Gallery Image IDs and Shared Gallery Image Version ID"
}

variable "prefix" {
  type        = string
  default     = "avdtf"
  description = "Prefix of the name of the AVD machine(s)"
}

variable "domain_name" {
  type        = string
  default     = "infra.local"
  description = "Name of the domain to join"
}

variable "domain_user_upn" {
  type        = string
  default     = "domainjoineruser" # do not include domain name as this is appended
  description = "Username for domain join (do not include domain name as this is appended)"
}

variable "domain_password" {
  type        = string
  default     = "ChangeMe123!"
  description = "Password of the user to authenticate with the domain"
  sensitive   = true
}

variable "vm_size" {
  description = "Size of the machine to deploy"
  default     = "Standard_DS2_v2"
}

variable "ou_path" {
  default = ""
}

variable "local_admin_username" {
  type        = string
  default     = "localadm"
  description = "local admin username"
}

variable "local_admin_password" {
  type        = string
  default     = "ChangeMe123!"
  description = "local admin password"
  sensitive   = true
}

variable "host_pool_type" {
  description = "(Required) The type of the Virtual Desktop Host Pool. Valid options are Personal or Pooled. Changing the type forces a new resource to be created."
  default     = "Pooled"
}

variable "maximum_sessions_allowed" {
  description = "(Optional) A valid integer value from 0 to 999999 for the maximum number of users that have concurrent sessions on a session host. Should only be set if the type of your Virtual Desktop Host Pool is Pooled."
  default     = 20
}

variable "load_balancer_type" {
  description = " (Required) BreadthFirst load balancing distributes new user sessions across all available session hosts in the host pool. Possible values are BreadthFirst, DepthFirst and Persistent. DepthFirst load balancing distributes new user sessions to an available session host with the highest number of connections but has not reached its maximum session limit threshold. Persistent should be used if the host pool type is Personal"
  default     = "BreadthFirst"
}
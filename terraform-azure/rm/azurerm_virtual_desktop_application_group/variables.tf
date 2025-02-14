variable "name" {
  description = "(Required) The name of the Virtual Desktop Application Group. Changing the name forces a new resource to be created."
}

variable "location" {
  description = "(Required) The location/region where the Virtual Desktop Application Group is located. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  description = " (Required) The name of the resource group in which to create the Virtual Desktop Application Group. Changing this forces a new resource to be created."
}

variable "type" {
  description = "(Required) Type of Virtual Desktop Application Group. Valid options are RemoteApp or Desktop application groups. Changing this forces a new resource to be created."
  default     = "RemoteApp"
}

variable "host_pool_id" {
  description = "(Required) Resource ID for a Virtual Desktop Host Pool to associate with the Virtual Desktop Application Group. Changing the name forces a new resource to be created."
}

variable "friendly_name" {
  description = " (Optional) Option to set a friendly name for the Virtual Desktop Application Group."
}

variable "description" {
  description = "(Optional) Option to set a description for the Virtual Desktop Application Group."
}
variable "name" {
  description = "(Required) The name of the Virtual Desktop Workspace. Changing this forces a new resource to be created."
}

variable "location" {
  description = "(Required) The location/region where the Virtual Desktop Workspace is located. Changing the location/region forces a new resource to be created."
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Virtual Desktop Workspace. Changing this forces a new resource to be created."
}

variable "friendly_name" {
  description = "(Optional) A friendly name for the Virtual Desktop Workspace."
}

variable "description" {
  description = " (Optional) A description for the Virtual Desktop Workspace."
}
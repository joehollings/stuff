variable "name" {
  description = "(Required) The name which should be used for this Virtual Desktop Scaling Plan . Changing this forces a new Virtual Desktop Scaling Plan to be created."
}

variable "location" {
  description = "(Required) The Azure Region where the Virtual Desktop Scaling Plan should exist. Changing this forces a new Virtual Desktop Scaling Plan to be created."
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group where the Virtual Desktop Scaling Plan should exist. Changing this forces a new Virtual Desktop Scaling Plan to be created."
}

variable "friendly_name" {
  description = "(Optional) Friendly name of the Scaling Plan."
}

variable "description" {
  description = "(Optional) A description of the Scaling Plan."
}

variable "time_zone" {
  description = "(Required) Specifies the Time Zone which should be used by the Scaling Plan for time based events"
  default     = "GMT Standard Time"
}

variable "hostpool_id" {
  description = "(Required) The ID of the HostPool to assign the Scaling Plan to."
}

variable "scaling_plan_enabled" {
  description = "(Required) Specifies if the scaling plan is enabled or disabled for the HostPool."
}
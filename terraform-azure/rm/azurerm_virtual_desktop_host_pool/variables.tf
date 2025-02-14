variable "location" {
  description = "Resource Group location"
}

variable "resource_group_name" {
  description = "Resource Group name"
}

variable "name" {
  description = "(Required) The name of the Virtual Desktop Host Pool. Changing this forces a new resource to be created."
}

variable "friendly_name" {
  description = "(Optional) A friendly name for the Virtual Desktop Host Pool."
}

variable "validate_environment" {
  description = "(Optional) Allows you to test service changes before they are deployed to production. Defaults to false"
  default     = true
}

variable "start_vm_on_connect" {
  description = "(Optional) Enables or disables the Start VM on Connection Feature. Defaults to false."
  default     = true
}

variable "custom_rdp_properties" {
  description = "(Optional) A valid custom RDP properties string for the Virtual Desktop Host Pool."
  default     = "audiocapturemode:i:1;audiomode:i:0;"
}

variable "description" {
  description = "(Optional) A description for the Virtual Desktop Host Pool."
}

variable "type" {
  description = "(Required) The type of the Virtual Desktop Host Pool. Valid options are Personal or Pooled. Changing the type forces a new resource to be created."
  default     = "Pooled"
}

variable "maximum_sessions_allowed" {
  description = " (Optional) A valid integer value from 0 to 999999 for the maximum number of users that have concurrent sessions on a session host. Should only be set if the type of your Virtual Desktop Host Pool is Pooled."
}

variable "load_balancer_type" {
  description = " (Required) BreadthFirst load balancing distributes new user sessions across all available session hosts in the host pool. Possible values are BreadthFirst, DepthFirst and Persistent. DepthFirst load balancing distributes new user sessions to an available session host with the highest number of connections but has not reached its maximum session limit threshold. Persistent should be used if the host pool type is Personal"
  default     = "DepthFirst"
}

variable "scheduled_agent_updates" {
  description = "(Optional) Enables or disables scheduled updates of the AVD agent components (RDAgent, Geneva Monitoring agent, and side-by-side stack) on session hosts. If this is enabled then up to two schedule blocks must be defined. Default is false."
  default     = true
}

variable "day_of_week" {
  description = "(Required) The day of the week on which agent updates should be performed. Possible values are Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, and Sunday"
  default     = "Saturday"
}

variable "hour_of_day" {
  description = "(Required) The hour of day the update window should start. The update is a 2 hour period following the hour provided. The value should be provided as a number between 0 and 23, with 0 being midnight and 23 being 11pm. A leading zero should not be used."
  default     = 2
}
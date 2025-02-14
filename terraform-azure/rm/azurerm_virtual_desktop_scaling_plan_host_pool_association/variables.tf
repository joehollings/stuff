variable "host_pool_id" {
  description = "(Required) The resource ID for the Virtual Desktop Host Pool. Changing this forces a new resource to be created."
}

variable "scaling_plan_id" {
  description = "(Required) The resource ID for the Virtual Desktop Scaling Plan. Changing this forces a new resource to be created."
}

variable "enabled" {
  description = "(Required) Should the Scaling Plan be enabled on this Host Pool."
  default     = true
}
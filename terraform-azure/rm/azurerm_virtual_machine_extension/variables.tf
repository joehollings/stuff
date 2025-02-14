variable "virtual_machine_id" {
  description = "(Required) The ID of the Virtual Machine. Changing this forces a new resource to be created"
  type        = string
}

variable "powershell_command" {
  description = "Powershell command to run"
  type        = string
}

variable "name" {
  description = "(Required) The name of the Virtual Desktop Application. Changing the name forces a new resource to be created."
}

variable "application_group_id" {
  description = "(Required) Resource ID for a Virtual Desktop Application Group to associate with the Virtual Desktop Application. Changing this forces a new resource to be created."
}

variable "friendly_name" {
  description = "(Optional) Option to set a friendly name for the Virtual Desktop Application."
}

variable "description" {
  description = " (Optional) Option to set a description for the Virtual Desktop Application."
}

variable "path" {
  description = "(Required) The file path location of the app on the Virtual Desktop OS. ex C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe"
}

variable "command_line_argument_policy" {
  description = "(Required) Specifies whether this published application can be launched with command line arguments provided by the client, command line arguments specified at publish time, or no command line arguments at all. Possible values include: DoNotAllow, Allow, Require."
  default     = "DoNotAllow"
}

variable "command_line_arguments" {
  description = "(Optional) Command Line Arguments for Virtual Desktop Application."
  default     = null
}

variable "show_in_portal" {
  description = "(Optional) Specifies whether to show the RemoteApp program in the RD Web Access server."
  default     = false
}

variable "icon_index" {
  description = "(Optional) The index of the icon you wish to use."
  default     = 0
}
variable "private_endpoint_name" {
  description = "(Required) Specifies the Name of the Private Endpoint. Changing this forces a new resource to be created."
}

variable "location" {
  description = "(Required) The supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  description = "(Required) Specifies the Name of the Resource Group within which the Private Endpoint should exist. Changing this forces a new resource to be created."
}

variable "subnet_id" {
  description = "(Required) The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint. Changing this forces a new resource to be created."
}

variable "private_service_connection_name" {
  description = "(Required) Specifies the Name of the Private Service Connection. Changing this forces a new resource to be created."
}

variable "private_connection_resource_id" {
  description = "(Optional) The ID of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to. One of private_connection_resource_id or private_connection_resource_alias must be specified. Changing this forces a new resource to be created. For a web app or function app slot, the parent web app should be used in this field instead of a reference to the slot itself."
}

variable "subresource_names" {
  description = "(Optional) A list of subresource names which the Private Endpoint is able to connect to. subresource_names corresponds to group_id. Possible values are detailed in the product documentation in the Subresources column. Changing this forces a new resource to be created."
}

variable "is_manual_connection" {
  description = "(Required) Does the Private Endpoint require Manual Approval from the remote resource owner? Changing this forces a new resource to be created."
  default     = false
}

variable "private_dns_zone_group_name" {
  description = "(Required) Specifies the Name of the Private DNS Zone Group."
}

variable "private_dns_zone_ids" {
  description = "(Required) Specifies the list of Private DNS Zones to include within the private_dns_zone_group."
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = null
}
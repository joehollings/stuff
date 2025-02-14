# Use variables to customize the deployment

variable "location" {
  type    = string
  default = "uksouth"
}

variable "admin_username" {
  description = "Admin username for Virtual Machines. Stored as a Github secret"
  type        = string
  sensitive   = true
}

variable "admin_password" {
  description = "Admin password for Virtual Machines. Stored as a Github secret"
  type        = string
  sensitive   = true
}

variable "kab-hub-uksouth_id" {
  type    = string
  default = "/subscriptions/ab545a1d-96bb-41f7-a3a6-90c386081229/resourceGroups/kab-connectivity-uksouth/providers/Microsoft.Network/virtualNetworks/kab-hub-uksouth"
}

variable "kab-hub-uksouth" {
  type    = string
  default = "/subscriptions/ab545a1d-96bb-41f7-a3a6-90c386081229/resourceGroups/kab-connectivity-uksouth/providers/Microsoft.Network/dnsForwardingRulesets/kab-hub-uksouth"
}

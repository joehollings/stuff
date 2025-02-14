# Use variables to customize the deployment

variable "root_id" {
  type    = string
  default = "kab"
}

variable "root_name" {
  type    = string
  default = "Kabeelah Cloud"
}

variable "connectivity_resources_location" {
  type    = string
  default = "uksouth"
}

variable "connectivity_resources_tags" {
  type = map(string)
  default = {
    customer    = "kabeelah",
    project     = "kabeelah cloud",
    environment = "prod"
  }
}

variable "log_retention_in_days" {
  type    = number
  default = 30
}

variable "security_alerts_email_address" {
  type    = string
  default = "joe.hollings@kabeelah.com" # Replace this value with your own email address.
}

variable "management_resources_location" {
  type    = string
  default = "uksouth"
}

variable "management_resources_tags" {
  type = map(string)
  default = {
    customer    = "kabeelah",
    project     = "kabeelah cloud",
    environment = "prod"
  }
}

variable "subscription_id_identity" {
  type    = string
  default = "9d1bd893-3bdf-4603-870e-32ceaecd3ac6"
}
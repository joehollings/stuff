variable "client_id" {
  type    = string
  default = "${env("client_id")}"
}

variable "client_secret" {
  type      = string
  default   = "${env("client_secret")}"
  sensitive = true
}

variable "subscription_id" {
  type    = string
  default = "${env("subid")}"
}

variable "tenant_id" {
  type    = string
  default = "${env("tenantid")}"
}

variable "location" {
  type    = string
  default = "${env("location")}"
}

variable "access_key" {
  type    = string
  default = "${env("access_key")}"
}

variable "reg_key" {
  type    = string
  default = "${env("reg_key")}"
}

variable "managed_image_name" {
  type    = string
  default = "${env("managed_image_name")}"
}

variable "managed_image_resource_group_name" {
  type    = string
  default = "${env("managed_image_resource_group_name")}"
}

source "azure-arm" "linuxvm" {
  async_resourcegroup_delete        = true
  client_id                         = var.client_id
  client_secret                     = var.client_secret
  image_offer                       = "sles-15-sp3-byos"
  image_publisher                   = "SUSE"
  image_sku                         = "gen2"
  location                          = var.location
  managed_image_name                = var.managed_image_name
  managed_image_resource_group_name = var.managed_image_resource_group_name
  os_type                           = "Linux"
  subscription_id                   = var.subscription_id
  tenant_id                         = var.tenant_id
  vm_size                           = "Standard_D2_v5"
}

build {
  sources = ["source.azure-arm.linuxvm"]

  provisioner "shell" {
    environment_vars  = ["access_key=${var.access_key}", "reg_key=${var.reg_key}"]
    execute_command   = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    script            = "./packer/bash/suse.sh"
    expect_disconnect = true
  }
  provisioner "shell" {
    environment_vars  = ["access_key=${var.access_key}", "reg_key=${var.reg_key}"]
    execute_command   = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    script            = "./packer/bash/suse.sh"
    expect_disconnect = true
  }
  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
  }
}
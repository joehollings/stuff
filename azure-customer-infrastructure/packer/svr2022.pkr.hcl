packer {
  required_plugins {
    windows-update = {
      version = "0.14.1"
      source  = "github.com/rgl/windows-update"
    }
  }
}

variable "WorkingDirectory" {
  type    = string
  default = ""
}

variable "client_id" {
  type    = string
  default = "${env("client_id")}"
}

variable "client_secret" {
  type      = string
  default   = "${env("client_secret")}"
  sensitive = true
}

variable "location" {
  type    = string
  default = "${env("location")}"
}

variable "managed_image_name" {
  type    = string
  default = "${env("managed_image_name")}"
}

variable "managed_image_resource_group_name" {
  type    = string
  default = "${env("managed_image_resource_group_name")}"
}

variable "offer" {
  type    = string
  default = "${env("offer")}"
}

variable "publisher" {
  type    = string
  default = "${env("publisher")}"
}

variable "sku" {
  type    = string
  default = "${env("sku")}"
}

variable "subscription_id" {
  type    = string
  default = "${env("subid")}"
}

variable "tenant_id" {
  type    = string
  default = "${env("tenantid")}"
}

variable "SAStoken" {
  type    = string
  default = "${env("SAStoken")}"
}

variable "vm_size" {
  type    = string
  default = "${env("vm_size")}"
}

source "azure-arm" "windowsvm" {
  async_resourcegroup_delete             = true
  client_id                              = var.client_id
  client_secret                          = var.client_secret
  communicator                           = "winrm"
  image_offer                            = "WindowsServer"
  image_publisher                        = "MicrosoftWindowsServer"
  image_sku                              = "2022-datacenter-azure-edition"
  location                               = var.location
  managed_image_name                     = var.managed_image_name
  managed_image_resource_group_name      = var.managed_image_resource_group_name
  os_type                                = "Windows"
  private_virtual_network_with_public_ip = "false"
  subscription_id                        = var.subscription_id
  tenant_id                              = var.tenant_id
  vm_size                                = "Standard_D2_v5"
  winrm_insecure                         = "true"
  winrm_timeout                          = "3m"
  winrm_use_ssl                          = "true"
  winrm_username                         = "packer"
}

build {
  sources = ["source.azure-arm.windowsvm"]

  provisioner "windows-update" {
    filters         = ["exclude:$_.Title -like '*Preview*'", "include:$true"]
    search_criteria = "IsInstalled=0"
    update_limit    = 25
  }
  provisioner "windows-restart" {
    restart_check_command = "powershell -command \"&amp; {Write-Output 'Machine restarted.'}\""
  }
  provisioner "powershell" {
    environment_vars = ["SAStoken=${var.SAStoken}"]
    script           = "./packer/powershell/packages/cccopy.ps1"
  }
  provisioner "powershell" {
    inline = ["if( Test-Path $Env:SystemRoot\\windows\\system32\\Sysprep\\unattend.xml ){ rm $Env:SystemRoot\\windows\\system32\\Sysprep\\unattend.xml -Force}", "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit /mode:vm", "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; Write-Output $imageState.ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Start-Sleep -s 10 } else { break } }"]
  }
}
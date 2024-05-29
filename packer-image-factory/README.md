# Packer Image Factory

Uses Github actions to build and update golden images on a schdule for use in Azure automation. There are the following OS's configured:

* Windows 10 Multi Session 22H2
* Windows Server 2019
* Windows Server 2022 Azure Addition
* Windows Server 2022 Datacenter
* SUSE SLES 15 SP3 - Configured for SAP Hana
* Ubuntu Server 2004 LTS - Configured as a self hosted GitHub runner

## Usage

* Create a Packer template by copying one of the existing ones
* Customise the Build section of the template with any custom scripts, see the bash and powershell folders for sample scripts
* Create a github workflow file by copying an existing one customising with the new packer template you created

## Packer template example Windows

```hcl

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

```

## Packer template example Linux

```hcl

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

```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| Name | Description | `string` | `""` | yes |

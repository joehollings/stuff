# Azure Linux Virtual Machine for SAP HANA

Terraform module to deploy a SAP HANA server with required data disks.

## Re development required

* Create Ansible runbook to configure OS
* Create Ansible runbook to configure Storage
* Create Ansible runbook to configure Hana

## Usage

Currently a post install script customisies and copies a Hana install script to /tmp/install_hana.sh. After server deployment is complete, reboot the vm, then ssh to the server and run the script. This will do the following:

* Register system with SUSE
* Configure storage
* Add new volumes to fstab
* Run SAP Tune
* Install SAP HANA

Call using the following Terraform module block:

```hcl
module "hana" {
  source                       = "git@github.com:<org_name>/terraform-azure-linux-hana?ref=v1.0.0"
  for_each                     = local.hana
  resource_group_name          = ""
  location                     = ""
  computer_name                = "az${local.customer_number}${each.value.hana_sid}hdb01"
  subnet_id                    = ""
  subnet_name                  = ""
  size                         = each.value.size
  zone                         = each.value.zone
  proximity_placement_group_id = each.value.proximity_placement_group_id
  source_image_id              = data.azurerm_image.hana.id
  admin_user                   = local.admin_username
  admin_password               = data.azurerm_key_vault_secret.<secret_name>.value
  hana_sid                     = each.value.hana_sid
  managed_disk                 = lookup(each.value, "disks", {})
  tags_customer                = local.customer_name
  tags_environment             = each.key
  tags_project                 = "10${local.customer_number}"
}
```

Ensure an Azure Key Vault data source is available to retrieve required admin password.

Supply the following values via locals:

```hcl
admin_username                = ""
key_vault_name                = ""
key_vault_resource_group_name = ""
hana = {
    env = {
      size                         = "Standard_E16s_v5"
      hana_id                      = "01"
      hana_sid                     = ""
      zone                         = ""
      proximity_placement_group_id = ""
      disks = {
        # usr sap
        sdb = {
          name                 = "-usr_sap"
          size                 = 64
          lun                  = 0
          caching              = "None"
          storage_account_type = "Premium_LRS"
        }
        # hana shared
        sdc = {
          name                 = "-hana_shared"
          size                 = 64
          lun                  = 1
          caching              = "None"
          storage_account_type = "Premium_LRS"
        }
        # data
        sdd = {
          name                 = "-hana_data_01"
          size                 = 128
          lun                  = 2
          caching              = "None"
          storage_account_type = "Premium_LRS"
        }
        # data
        sde = {
          name                 = "-hana_data_02"
          size                 = 128
          lun                  = 3
          caching              = "None"
          storage_account_type = "Premium_LRS"
        }
        # data
        sdf = {
          name                 = "-hana_data_03"
          size                 = 128
          lun                  = 4
          caching              = "None"
          storage_account_type = "Premium_LRS"
        }
        # data
        sdg = {
          name                 = "-hana_data_04"
          size                 = 128
          lun                  = 5
          caching              = "None"
          storage_account_type = "Premium_LRS"
        }
        # log
        sdh = {
          name                 = "-hana_log_01"
          size                 = 64
          lun                  = 6
          caching              = "None"
          storage_account_type = "Premium_LRS"
        }
        # log
        sdi = {
          name                 = "-hana_log_02"
          size                 = 64
          lun                  = 7
          caching              = "None"
          storage_account_type = "Premium_LRS"
        }
        # log
        sdj = {
          name                 = "-hana_log_03"
          size                 = 64
          lun                  = 8
          caching              = "None"
          storage_account_type = "Premium_LRS"
        }
        # log
        sdk = {
          name                 = "-hana_log_04"
          size                 = 64
          lun                  = 9
          caching              = "None"
          storage_account_type = "Premium_LRS"
        }
        # log
        sdl = {
          name                 = "-hana_log_05"
          size                 = 64
          lun                  = 10
          caching              = "None"
          storage_account_type = "Premium_LRS"
        }
      }
    }
  }
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| admin_password | ROOT Password | `string` | `""` | yes |
| admin_user | Root Username | `string` | `""` | yes |
| computer_name | Computer and Host name | `string` | `""` | yes |
| data_disk_create_option | The method to use when creating the managed disk | `string` | `"empty"` | no |
| disable_password_authentication | Should Password Authentication be disabled on this Virtual Machine? | `bool` | `false` | no |
| enable_accelerated_networking | Enable Accelerated Networking | `bool` | `true` | no |
| hana_id | SAP HANA system number | `string` | `""` | yes |
| hana_sid | SAP HANA system ID or instance name for you SQL peeps | `string` | `""` | yes |
| install_script | Name of install script to use for HANA install | `string` | `"hana_install.sh"` | no |
| license_type | Specifies the BYOL Type for this Virtual Machine. Possible values are RHEL_BYOS and SLES_BYOS | `string` | `""` | yes |
| location | The Azure location where the Linux Virtual Machine should exist | `string` | `"uksouth"` | yes |
| managed_disk | Map of managed disks to create and attach to VM | `any` | {} | no |
| os_disk_caching | The Type of Caching which should be used for the Internal OS Disk | `string` | `"ReadWrite"` | no |
| os_disk_name | he name which should be used for the Internal OS Disk | `string` | `""` | yes |
| os_disk_storage_account_type | The Type of Storage Account which should back this the Internal OS Disk | `string` | `"Premium_LRS"` |no |
| private_ip_address_allocation | The allocation method used for the Private IP Address. Possible values are Dynamic and Static | `string` | `"Dynamic"` | no |
| proximity_placement_group_id | ID of the Proximity Placement Group | `string` | `""` | yes |
| resource_group_name | The name of the Resource Group in which the Linux Virtual Machine should be exist | `string` | `""` | yes |
| size | The SKU which should be used for this Virtual Machine, such as Standard_F2 | `string` | `""` | yes |
| source_image_id | The ID of the Image which this Virtual Machine should be created from. Changing this forces a new resource to be created. Possible Image ID types include Image IDs, Shared Image IDs, Shared Image Version IDs, Community Gallery Image IDs, Community Gallery Image Version IDs, Shared Gallery Image IDs and Shared Gallery Image Version IDs | `string` | `""` | yes |
| subnet_id | The ID of the Subnet where this Network Interface should be located in | `string` | `""` | yes |
| subnet_name | Name used for this IP Configuration | `string` | `""` | yes |
| tags_application | Application name tag | `string` | `"SAP"` | no |
| tags_customer | Customer name tag | `tring` | `""` | yes |
| tags_environment | Environment tag | `string` | `""` | yes |
| tags_project | Customer number tag | `string` | `""` | yes |
| zone | Specifies the Availability Zones in which this Linux Virtual Machine should be located | `string` | `""` | yes |

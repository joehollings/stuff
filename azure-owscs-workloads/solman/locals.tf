locals {
  customer_number               = "cs"
  customer_name                 = "OWSCS"
  location                      = "UK South"
  key_vault_name                = "kv-owscs-hub"
  key_vault_resource_group_name = "rg-owscs-hub"
  admin_username                = "owscs-admin"
  admin_password_secret_name    = "OWSCS-Admin"
  hub_vnet_name                 = "vnet-hub"
  hub_subnet_name               = "snet-identityservices"

  sap = {
    prod = {
      computer_name                = "azcssol01"
      subnet_name                  = data.azurerm_subnet.snet-sharedresources.name
      subnet_id                    = data.azurerm_subnet.snet-sharedresources.id
      size                         = "Standard_D8s_v5"
      zone                         = "2"
      proximity_placement_group_id = azurerm_proximity_placement_group.solman.id
      backup_policy_id             = data.azurerm_backup_policy_vm.WeeklyVMBackup.id
      disks = {
        data = {
          name                 = "-data_01"
          size                 = 128
          lun                  = 0
          caching              = "None"
          storage_account_type = "Premium_LRS"
        }
        page = {
          name                 = "-page_01"
          size                 = 64
          lun                  = 1
          caching              = "None"
          storage_account_type = "Premium_LRS"
        }
      }
    }
  }

  hana = {
    prod = {
      size                         = "Standard_E20s_v5"
      hana_id                      = "01"
      hana_sid                     = "sp2"
      zone                         = "2"
      proximity_placement_group_id = azurerm_proximity_placement_group.solman.id
      install_script               = "solman.sh"
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
}
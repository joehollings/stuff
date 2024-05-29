locals {
  customer_number               = "cs"
  customer_name                 = "OWSCS"
  location                      = "UK South"
  key_vault_name                = "kv-owscs-hub"
  key_vault_resource_group_name = "rg-owscs-hub"
  admin_username                = "owscs-admin"
  admin_password_secret_name    = "OWSCS-Admin"
  ad_admin_username             = "joe.hollings.adm"
  ad_admin_password_secret_name = "OWSCS-Joe-ADM"
  suse_reg_code                 = "suse-key"
  hub_vnet_name                 = "vnet-hub"
  hub_subnet_name               = "snet-identityservices"

  bpc = {
    nw75008101 = {
      computer_name                = ""
      subnet_name                  = data.azurerm_subnet.snet-sharedresources.name
      subnet_id                    = data.azurerm_subnet.snet-sharedresources.id
      size                         = "Standard_D4s_v5"
      zone                         = "1"
      proximity_placement_group_id = azurerm_proximity_placement_group.sap_test.id
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
    dw20003111 = {
      computer_name                = ""
      subnet_name                  = data.azurerm_subnet.snet-sharedresources.name
      subnet_id                    = data.azurerm_subnet.snet-sharedresources.id
      size                         = "Standard_D4s_v5"
      zone                         = "1"
      proximity_placement_group_id = azurerm_proximity_placement_group.sap_test.id
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
    # dw20010111 = {
    #   computer_name                = ""
    #   subnet_name                  = data.azurerm_subnet.snet-sharedresources.name
    #   subnet_id                    = data.azurerm_subnet.snet-sharedresources.id
    #   size                         = "Standard_D4s_v5"
    #   zone                         = "1"
    #   proximity_placement_group_id = azurerm_proximity_placement_group.sap_test.id
    #   backup_policy_id             = data.azurerm_backup_policy_vm.WeeklyVMBackup.id
    #   disks = {
    #     data = {
    #       name                 = "-data_01"
    #       size                 = 128
    #       lun                  = 0
    #       caching              = "None"
    #       storage_account_type = "Premium_LRS"
    #     }
    #     page = {
    #       name                 = "-page_01"
    #       size                 = 64
    #       lun                  = 1
    #       caching              = "None"
    #       storage_account_type = "Premium_LRS"
    #     }
    #   }
    # }
    # nw75208101 = {
    #   computer_name                = ""
    #   subnet_name                  = data.azurerm_subnet.snet-sharedresources.name
    #   subnet_id                    = data.azurerm_subnet.snet-sharedresources.id
    #   size                         = "Standard_D4s_v5"
    #   zone                         = "1"
    #   proximity_placement_group_id = azurerm_proximity_placement_group.sap_test.id
    #   backup_policy_id             = data.azurerm_backup_policy_vm.WeeklyVMBackup.id
    #   disks = {
    #     data = {
    #       name                 = "-data_01"
    #       size                 = 128
    #       lun                  = 0
    #       caching              = "None"
    #       storage_account_type = "Premium_LRS"
    #     }
    #     page = {
    #       name                 = "-page_01"
    #       size                 = 64
    #       lun                  = 1
    #       caching              = "None"
    #       storage_account_type = "Premium_LRS"
    #     }
    #   }
    # }
    # dw20008111 = {
    #   computer_name                = ""
    #   subnet_name                  = data.azurerm_subnet.snet-sharedresources.name
    #   subnet_id                    = data.azurerm_subnet.snet-sharedresources.id
    #   size                         = "Standard_D4s_v5"
    #   zone                         = "1"
    #   proximity_placement_group_id = azurerm_proximity_placement_group.sap_test.id
    #   backup_policy_id             = data.azurerm_backup_policy_vm.WeeklyVMBackup.id
    #   disks = {
    #     data = {
    #       name                 = "-data_01"
    #       size                 = 128
    #       lun                  = 0
    #       caching              = "None"
    #       storage_account_type = "Premium_LRS"
    #     }
    #     page = {
    #       name                 = "-page_01"
    #       size                 = 64
    #       lun                  = 1
    #       caching              = "None"
    #       storage_account_type = "Premium_LRS"
    #     }
    #   }
    # }
    dw3000421 = {
      computer_name                = ""
      subnet_name                  = data.azurerm_subnet.snet-sharedresources.name
      subnet_id                    = data.azurerm_subnet.snet-sharedresources.id
      size                         = "Standard_D4s_v5"
      zone                         = "1"
      proximity_placement_group_id = azurerm_proximity_placement_group.sap_test.id
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
    azcsinthdb01 = {
      size                         = "Standard_E16s_v5"
      hana_id                      = "01"
      hana_sid                     = "t01"
      zone                         = "1"
      proximity_placement_group_id = azurerm_proximity_placement_group.sap_test.id
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
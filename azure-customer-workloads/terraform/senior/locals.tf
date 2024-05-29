locals {
  customer_number               = "110"
  customer_name                 = "Senior"
  location                      = "UK South"
  key_vault_name                = "kv-owscs-hub"
  key_vault_resource_group_name = "rg-owscs-hub"
  admin_username                = "owscs-admin"
  admin_password_secret_name    = "OWSCS-Admin"
  hub_vnet_name                 = "vnet-hub"
  hub_subnet_name               = "snet-identityservices"
  hana_dev_sid                  = "sp1"
  hana_qas_sid                  = "sp2"
  hana_prod_sid                 = "sp3"

  virtual_networks = {
    prod = {
      address_space               = ["10.11.12.0/22"]
      network_security_group_name = "nsg-vnet-app-prod"
      subnets = {
        snet-presentation-prod = {
          address_prefixes = ["10.11.12.0/24"]
        }
        snet-dev-test-prod = {
          address_prefixes = ["10.11.13.0/24"]
        }
        snet-sap-prod = {
          address_prefixes = ["10.11.14.0/24"]
        }
        snet-db-prod = {
          address_prefixes = ["10.11.15.0/24"]
        }
      }
    }
  }

  proximity_placement_groups = {
    dev = {
      name = "10${local.customer_number}-ppg-sap-dev"
    }
    qas = {
      name = "10${local.customer_number}-ppg-sap-qas"
    }
    prod = {
      name = "10${local.customer_number}-ppg-sap-prod"
    }
  }

  storage_accounts = {
    prod = {
      name        = "10${local.customer_number}afs01"
      storage_sid = "S-1-5-21-2079600466-3062766412-2793361815-5607"
      shares = {
        shared = {
          quota = "256"
        }
        backup = {
          quota = "512"
        }
      }
    }
  }

  # dc_cc = {
  #   dc01 = {
  #     computer_name                = "az${local.customer_number}wdc01"
  #     subnet_name                  = "${data.azurerm_subnet.snet-identityservices.name}"
  #     subnet_id                    = "${data.azurerm_subnet.snet-identityservices.id}"
  #     zone                         = "1"
  #     size                         = "Standard_B2s"
  #     license_type                 = "None"
  #     source_image_reference_offer = "WindowsServer"
  #     source_image_reference_sku   = "2022-datacenter-azure-edition"
  #     backup_policy_id             = "${azurerm_backup_policy_vm.DailyVMBackup.id}"
  #   }

  #   dc02 = {
  #     computer_name                = "az${local.customer_number}wdc02"
  #     subnet_name                  = "${data.azurerm_subnet.snet-identityservices.name}"
  #     subnet_id                    = "${data.azurerm_subnet.snet-identityservices.id}"
  #     zone                         = "2"
  #     size                         = "Standard_B2s"
  #     license_type                 = "None"
  #     source_image_reference_offer = "WindowsServer"
  #     source_image_reference_sku   = "2022-datacenter-azure-edition"
  #     backup_policy_id             = "${azurerm_backup_policy_vm.DailyVMBackup.id}"
  #   }

  #   cc01 = {
  #     computer_name                = "az${local.customer_number}ccc01"
  #     subnet_name                  = "${data.azurerm_subnet.snet-identityservices.name}"
  #     subnet_id                    = "${data.azurerm_subnet.snet-identityservices.id}"
  #     zone                         = "1"
  #     size                         = "Standard_D2s_v5"
  #     license_type                 = "Windows_Server"
  #     source_image_reference_offer = "WindowsServer"
  #     source_image_reference_sku   = "2022-datacenter-azure-edition"
  #     backup_policy_id             = "${azurerm_backup_policy_vm.WeeklyVMBackup.id}"
  #   }

  #   cc02 = {
  #     computer_name                = "az${local.customer_number}ccc02"
  #     subnet_name                  = "${data.azurerm_subnet.snet-identityservices.name}"
  #     subnet_id                    = "${data.azurerm_subnet.snet-identityservices.id}"
  #     zone                         = "2"
  #     size                         = "Standard_D2s_v5"
  #     license_type                 = "Windows_Server"
  #     source_image_reference_offer = "WindowsServer"
  #     source_image_reference_sku   = "2022-datacenter-azure-edition"
  #     backup_policy_id             = "${azurerm_backup_policy_vm.WeeklyVMBackup.id}"
  #   }
  # }


  bpc = {
    # dev = {
    #   subnet_name                  = "${data.azurerm_subnet.snet-dev-test-prod.name}"
    #   subnet_id                    = "${data.azurerm_subnet.snet-dev-test-prod.id}"
    #   size                         = "Standard_D8s_v5"
    #   zone                         = "1"
    #   hana_sid                     = local.hana_dev_sid
    #   proximity_placement_group_id = "${data.azurerm_proximity_placement_group.dev.id}"
    #   source_image_reference_offer = "WindowsServer"
    #   source_image_reference_sku   = "2022-datacenter-g2"
    #   backup_policy_id             = "${azurerm_backup_policy_vm.WeeklyVMBackup.id}"
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
    prod = {
      subnet_name                  = "${data.azurerm_subnet.snet-sap-prod.name}"
      subnet_id                    = "${data.azurerm_subnet.snet-sap-prod.id}"
      size                         = "Standard_D8s_v5"
      zone                         = "2"
      hana_sid                     = local.hana_prod_sid
      proximity_placement_group_id = "${data.azurerm_proximity_placement_group.prod.id}"
      source_image_reference_offer = "WindowsServer"
      source_image_reference_sku   = "2022-datacenter-g2"
      #backup_policy_id             = "${azurerm_backup_policy_vm.WeeklyVMBackup.id}"
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

  vda = {
    # dev = {
    #   name = "az${local.customer_number}vdadevtemplate"
    #   zone = "1"
    #   size = "Standard_D2s_v5"
    # }
    prod = {
      name = "az${local.customer_number}vdadevtemplate"
      zone = "2"
      size = "Standard_D2s_v5"
    }
  }

  hana = {
    # dev = {
    #   size                         = "Standard_E16s_v5"
    #   hana_id                      = "01"
    #   hana_sid                     = local.hana_dev_sid
    #   zone                         = "1"
    #   proximity_placement_group_id = "${data.azurerm_proximity_placement_group.dev.id}"
    #   disks = {
    #     # usr sap
    #     sdb = {
    #       name                 = "-usr_sap"
    #       size                 = 64
    #       lun                  = 0
    #       caching              = "None"
    #       storage_account_type = "Premium_LRS"
    #     }
    #     # hana shared
    #     sdc = {
    #       name                 = "-hana_shared"
    #       size                 = 64
    #       lun                  = 1
    #       caching              = "None"
    #       storage_account_type = "Premium_LRS"
    #     }
    #     # data
    #     sdd = {
    #       name                 = "-hana_data_01"
    #       size                 = 128
    #       lun                  = 2
    #       caching              = "None"
    #       storage_account_type = "Premium_LRS"
    #     }
    #     # data
    #     sde = {
    #       name                 = "-hana_data_02"
    #       size                 = 128
    #       lun                  = 3
    #       caching              = "None"
    #       storage_account_type = "Premium_LRS"
    #     }
    #     # data
    #     sdf = {
    #       name                 = "-hana_data_03"
    #       size                 = 128
    #       lun                  = 4
    #       caching              = "None"
    #       storage_account_type = "Premium_LRS"
    #     }
    #     # data
    #     sdg = {
    #       name                 = "-hana_data_04"
    #       size                 = 128
    #       lun                  = 5
    #       caching              = "None"
    #       storage_account_type = "Premium_LRS"
    #     }
    #     # log
    #     sdh = {
    #       name                 = "-hana_log_01"
    #       size                 = 64
    #       lun                  = 6
    #       caching              = "None"
    #       storage_account_type = "Premium_LRS"
    #     }
    #     # log
    #     sdi = {
    #       name                 = "-hana_log_02"
    #       size                 = 64
    #       lun                  = 7
    #       caching              = "None"
    #       storage_account_type = "Premium_LRS"
    #     }
    #     # log
    #     sdj = {
    #       name                 = "-hana_log_03"
    #       size                 = 64
    #       lun                  = 8
    #       caching              = "None"
    #       storage_account_type = "Premium_LRS"
    #     }
    #     # log
    #     sdk = {
    #       name                 = "-hana_log_04"
    #       size                 = 64
    #       lun                  = 9
    #       caching              = "None"
    #       storage_account_type = "Premium_LRS"
    #     }
    #     # log
    #     sdl = {
    #       name                 = "-hana_log_05"
    #       size                 = 64
    #       lun                  = 10
    #       caching              = "None"
    #       storage_account_type = "Premium_LRS"
    #     }
    #   }
    # }
    prod = {
      size                         = "Standard_E32s_v5"
      hana_id                      = "01"
      hana_sid                     = local.hana_prod_sid
      zone                         = "2"
      proximity_placement_group_id = "${data.azurerm_proximity_placement_group.prod.id}"
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
locals {
  customer_number               = "001"
  customer_name                 = "PCS"
  customer_domain_name          = "${local.customer_name}.local"
  location                      = "UK South"
  key_vault_name                = "kv-owscs-hub"
  key_vault_resource_group_name = "rg-owscs-hub"
  admin_username                = "owscs-admin"
  admin_password_secret_name    = "OWSCS-Admin"
  forest_root_domain            = "owscs.local"
  ad_admin_username             = "joe.hollings.adm"
  ad_admin_password_secret_name = "OWSCS-Joe-ADM"
  hub_vnet_name                 = "vnet-hub"
  hub_subnet_name               = "snet-identityservices"

  # virtual_networks = {
  #   prod = {
  #     address_space               = ["10.11.24.0/22"]
  #     network_security_group_name = "nsg-vnet-app-prod"
  #     subnets = {
  #       snet-presentation-prod = {
  #         address_prefixes = ["10.11.24.0/24"]
  #       }
  #       snet-dev-test-prod = {
  #         address_prefixes = ["10.11.25.0/24"]
  #       }
  #       snet-sap-prod = {
  #         address_prefixes = ["10.11.26.0/24"]
  #       }
  #       snet-db-prod = {
  #         address_prefixes = ["10.11.27.0/24"]
  #       }
  #     }
  #   }
  # }

  virtual_networks = {
    prod = {
      address_space               = ["10.11.16.0/22"]
      network_security_group_name = "nsg-vnet-app-prod"
      subnets = {
        snet-presentation-prod = {
          address_prefixes = ["10.11.16.0/24"]
        }
        snet-dev-test-prod = {
          address_prefixes = ["10.11.17.0/24"]
        }
        snet-sap-prod = {
          address_prefixes = ["10.11.18.0/24"]
        }
        snet-db-prod = {
          address_prefixes = ["10.11.19.0/24"]
        }
      }
    }
  }

  proximity_placement_groups = {
    # dev = {
    #   name = "10${local.customer_number}-ppg-sap-dev"
    # }
    # qas = {
    #   name = "10${local.customer_number}-ppg-sap-qas"
    # }
    prod = {
      name = "11${local.customer_number}-ppg-sap-prod"
    }
  }

  storage_accounts = {
    prod = {
      name        = "11${local.customer_number}afs01"
      storage_sid = "S-1-5-21-2079600466-3062766412-2793361815-5609"
      shares = {
        data = {
          quota = "256"
        }
      }
    }
  }

  primary_dc = {
    dc01 = {
      computer_name    = "az${local.customer_number}wdc01"
      subnet_name      = data.azurerm_subnet.snet-identityservices.name
      subnet_id        = data.azurerm_subnet.snet-identityservices.id
      zone             = "1"
      size             = "Standard_B2s"
      license_type     = "None"
      backup_policy_id = azurerm_backup_policy_vm.WeeklyVMBackup.id
    }
  }

  dc_cc = {
    dc02 = {
      computer_name    = "az${local.customer_number}wdc02"
      subnet_name      = data.azurerm_subnet.snet-identityservices.name
      subnet_id        = data.azurerm_subnet.snet-identityservices.id
      zone             = "2"
      size             = "Standard_B2s"
      license_type     = "None"
      backup_policy_id = azurerm_backup_policy_vm.WeeklyVMBackup.id
    }

    cc01 = {
      computer_name    = "az${local.customer_number}ccc01"
      subnet_name      = data.azurerm_subnet.snet-identityservices.name
      subnet_id        = data.azurerm_subnet.snet-identityservices.id
      zone             = "1"
      size             = "Standard_D2s_v5"
      license_type     = "Windows_Server"
      backup_policy_id = azurerm_backup_policy_vm.WeeklyVMBackup.id
    }

    cc02 = {
      computer_name    = "az${local.customer_number}ccc02"
      ssubnet_name     = data.azurerm_subnet.snet-identityservices.name
      subnet_id        = data.azurerm_subnet.snet-identityservices.id
      zone             = "2"
      size             = "Standard_D2s_v5"
      license_type     = "Windows_Server"
      backup_policy_id = azurerm_backup_policy_vm.WeeklyVMBackup.id
    }
  }


  sun = {
    prod = {
      subnet_name                  = "${data.azurerm_subnet.snet-sap-prod.name}"
      subnet_id                    = "${data.azurerm_subnet.snet-sap-prod.id}"
      size                         = "Standard_D4s_v5"
      zone                         = "2"
      proximity_placement_group_id = "${data.azurerm_proximity_placement_group.prod.id}"
      backup_policy_id             = "${azurerm_backup_policy_vm.WeeklyVMBackup.id}"
      disks = {
        data = {
          name                 = "-data_01"
          size                 = 128
          lun                  = 0
          caching              = "None"
          storage_account_type = "Premium_LRS"
        }
      }
    }
  }

  sql = {
    prod = {
      subnet_name                  = "${data.azurerm_subnet.snet-sap-prod.name}"
      subnet_id                    = "${data.azurerm_subnet.snet-sap-prod.id}"
      size                         = "Standard_D4s_v5"
      zone                         = "2"
      proximity_placement_group_id = "${data.azurerm_proximity_placement_group.prod.id}"
      backup_policy_id             = "${azurerm_backup_policy_vm.WeeklyVMBackup.id}"
      disks = {
        app = {
          name                 = "-app_01"
          size                 = 32
          lun                  = 0
          caching              = "None"
          storage_account_type = "Premium_LRS"
        }
        data = {
          name                 = "-data_01"
          size                 = 64
          lun                  = 1
          caching              = "None"
          storage_account_type = "Premium_LRS"
        }
        log = {
          name                 = "-log_01"
          size                 = 64
          lun                  = 2
          caching              = "None"
          storage_account_type = "Premium_LRS"
        }
        tempdb = {
          name                 = "-tempdb_01"
          size                 = 32
          lun                  = 3
          caching              = "None"
          storage_account_type = "Premium_LRS"
        }
      }
    }
  }

  vda = {
    prod = {
      name     = "az${local.customer_number}vdadevtemplate"
      zone     = "2"
      size     = "Standard_D2s_v5"
      image_id = data.azurerm_image.vda.id
    }
  }
}
locals {
  customer_number                = "107"
  customer_name                  = "Uniphar"
  customer_domain_name           = "${local.customer_name}.local"
  location                       = "UK South"
  key_vault_name                 = "kv-owscs-hub"
  key_vault_resource_group_name  = "rg-owscs-hub"
  admin_username                 = "owscs-admin"
  admin_password_secret_name     = "OWSCS-Admin"
  vpn_pre_shared_key_secret_name = "uniphar-vpn-preshared-key"
  ad_admin_username              = "joe.hollings.adm"
  ad_admin_password_secret_name  = "OWSCS-Joe-ADM"
  hub_vnet_name                  = "vnet-hub"
  hub_subnet_name                = "snet-identityservices"
  hana_dev_sid                   = "p55"
  hana_qas_sid                   = "un2"
  hana_prod_sid                  = "c56"

  address_space_prod     = ["10.15.160.0/24"]
  snet-presentation-prod = ["10.15.160.0/26"]
  snet-sap-prod          = ["10.15.160.64/26"]
  snet-db-prod           = ["10.15.160.128/26"]

  address_space_dev     = ["10.16.160.0/24"]
  snet-presentation-dev = ["10.16.160.0/26"]
  snet-sap-dev          = ["10.16.160.64/26"]
  snet-db-dev           = ["10.16.160.128/26"]
  allow_gateway_transit = "false"


  virtual_networks = {
    prod = {
      address_space               = ["10.11.20.0/22", "10.0.0.0/28"]
      network_security_group_name = "nsg-vnet-app-prod"
      gateway_address             = "89.101.228.97"
      gateway_address_space       = ["172.16.11.0/24"]
      frontend_address_space      = ["10.${local.customer_number}.0.0/24"]
      gateway_subnet              = ["10.${local.customer_number}.0.0/28"]
      allow_gateway_transit       = "false"
      subnets = {
        snet-presentation-prod = {
          address_prefixes = ["10.11.20.0/24"]
        }
        snet-dev-test-prod = {
          address_prefixes = ["10.11.21.0/24"]
        }
        snet-sap-prod = {
          address_prefixes = ["10.11.22.0/24"]
        }
        snet-db-prod = {
          address_prefixes = ["10.11.23.0/24"]
        }
      }
    }
  }

  proximity_placement_groups = {
    dev = {
      name = "10${local.customer_number}-ppg-sap-dev"
    }
    # qas = {
    #   name = "10${local.customer_number}-ppg-sap-qas"
    # }
    prod = {
      name = "10${local.customer_number}-ppg-sap-prod"
    }
  }

  storage_accounts = {
    prod = {
      name        = "10${local.customer_number}afs01"
      storage_sid = "S-1-5-21-2079600466-3062766412-2793361815-4628"
      shares = {
        shared = {
          quota = "256"
        }
        backup = {
          quota = "1024"
        }
      }
    }
  }

  dc_cc = {
    dc01 = {
      computer_name    = "az${local.customer_number}wdc01"
      subnet_name      = "${data.azurerm_subnet.snet-identityservices.name}"
      subnet_id        = "${data.azurerm_subnet.snet-identityservices.id}"
      zone             = "1"
      size             = "Standard_B2s"
      license_type     = "None"
      backup_policy_id = "${azurerm_backup_policy_vm.DailyVMBackup.id}"
    }

    dc02 = {
      computer_name    = "az${local.customer_number}wdc02"
      subnet_name      = "${data.azurerm_subnet.snet-identityservices.name}"
      subnet_id        = "${data.azurerm_subnet.snet-identityservices.id}"
      zone             = "2"
      size             = "Standard_B2s"
      license_type     = "None"
      backup_policy_id = "${azurerm_backup_policy_vm.DailyVMBackup.id}"
    }

    cc01 = {
      computer_name    = "az${local.customer_number}ccc01"
      subnet_name      = "${data.azurerm_subnet.snet-identityservices.name}"
      subnet_id        = "${data.azurerm_subnet.snet-identityservices.id}"
      zone             = "1"
      size             = "Standard_D2s_v5"
      license_type     = "Windows_Server"
      backup_policy_id = "${azurerm_backup_policy_vm.WeeklyVMBackup.id}"
    }

    cc02 = {
      computer_name    = "az${local.customer_number}ccc02"
      subnet_name      = "${data.azurerm_subnet.snet-identityservices.name}"
      subnet_id        = "${data.azurerm_subnet.snet-identityservices.id}"
      zone             = "2"
      size             = "Standard_D2s_v5"
      license_type     = "Windows_Server"
      backup_policy_id = "${azurerm_backup_policy_vm.WeeklyVMBackup.id}"
    }
  }


  bpc = {
    dev = {
      subnet_name                  = "${data.azurerm_subnet.snet-dev-test-prod.name}"
      subnet_id                    = "${data.azurerm_subnet.snet-dev-test-prod.id}"
      size                         = "Standard_D8s_v5"
      zone                         = "1"
      hana_sid                     = local.hana_dev_sid
      proximity_placement_group_id = "${data.azurerm_proximity_placement_group.dev.id}"
      backup_policy_id             = "${azurerm_backup_policy_vm.WeeklyVMBackup.id}"
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
    prod = {
      subnet_name                  = "${data.azurerm_subnet.snet-sap-prod.name}"
      subnet_id                    = "${data.azurerm_subnet.snet-sap-prod.id}"
      size                         = "Standard_D8s_v5"
      zone                         = "2"
      hana_sid                     = local.hana_prod_sid
      proximity_placement_group_id = "${data.azurerm_proximity_placement_group.prod.id}"
      source_image_reference_offer = "WindowsServer"
      source_image_reference_sku   = "2022-datacenter-g2"
      backup_policy_id             = "${azurerm_backup_policy_vm.WeeklyVMBackup.id}"
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
    dev = {
      name     = "az${local.customer_number}vdadevtemplate"
      zone     = "1"
      size     = "Standard_D2s_v5"
      image_id = data.azurerm_image.vda2019ao.id
    }
    prod = {
      name     = "az${local.customer_number}vdadevtemplate"
      zone     = "2"
      size     = "Standard_D2s_v5"
      image_id = data.azurerm_image.vda2019ao.id
    }
  }

  hana = {
    dev = {
      size                         = "Standard_E16s_v5"
      hana_id                      = "01"
      hana_sid                     = "d55"
      zone                         = "1"
      proximity_placement_group_id = data.azurerm_proximity_placement_group.dev.id
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
    prod = {
      size                         = "Standard_E32s_v5"
      hana_id                      = "01"
      hana_sid                     = "p56"
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
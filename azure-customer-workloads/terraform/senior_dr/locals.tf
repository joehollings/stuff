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

  hana = {
    dr = {
      size                         = "Standard_E32s_v5"
      hana_id                      = "01"
      hana_sid                     = local.hana_prod_sid
      zone                         = "3"
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
locals {
  customer_number               = "cs"
  customer_name                 = "OWSCS"
  project                       = "00000"
  location                      = "UK South"
  suse_reg_code                 = "suse-key"
  key_vault_name                = "kv-owscs-hub"
  key_vault_resource_group_name = "rg-owscs-hub"
  admin_username                = "owscs-admin"
  admin_password_secret_name    = "OWSCS-Admin"
  hub_vnet_name                 = "vnet-hub"
  hub_subnet_name               = "snet-identityservices"

  beacon_servers = {
    azcsfbs01 = {
      subnet_name                  = data.azurerm_subnet.snet-sharedresources.name
      subnet_id                    = data.azurerm_subnet.snet-sharedresources.id
      size                         = "Standard_D2s_v5"
      zone                         = "1"
      disks = {
        data = {
          name                 = "-data_01"
          size                 = 32
          lun                  = 0
          caching              = "None"
          storage_account_type = "Premium_LRS"
        }
      }
    }
  }

  hana_cockpit = {
    azcshcp01 = {
      size                         = "Standard_E4s_v5"
      hana_id                      = "01"
      hana_sid                     = "hcp"
      zone                         = "2"
      proximity_placement_group_id = azurerm_proximity_placement_group.hcp.id
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
        # log
        sdf = {
          name                 = "-hana_log_01"
          size                 = 128
          lun                  = 4
          caching              = "None"
          storage_account_type = "Premium_LRS"
        }
      }
    }
  }
}
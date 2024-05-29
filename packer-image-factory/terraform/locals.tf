# locals {
#   customer_name                 = "OWSCS"
#   project                       = "00000"
#   environment                   = "prod"
#   location                      = "UK South"
#   key_vault_name                = "kv-owscs-hub"
#   key_vault_resource_group_name = "rg-owscs-hub"
#   suse_reg_code                 = "suse-key"
#   admin_username                = "owscs-admin"
#   admin_password_secret_name    = "OWSCS-Admin"
#   ad_admin_password_secret_name = "OWSCS-Joe-ADM"
#   vnet_name                     = "vnet-hub"
#   vnet_rsg_name                 = "rg-owscs-hub"
#   subnet_name                   = "snet-sharedresources"

#   windows = {
#     vm01 = {
#       computer_name = "azcsvmtest01"
#       name          = "azcsvmtest01"
#       subnet_name   = data.azurerm_subnet.this.name
#       subnet_id     = data.azurerm_subnet.this.id
#       zone          = "1"
#       size          = "Standard_D2s_v5"
#       image_id      = data.azurerm_image.win10win1022h2.id
#     }
#   }

#   linux = {
#     vm01 = {
#       computer_name = "azcst01hdb01"
#       subnet_name   = data.azurerm_subnet.this.name
#       subnet_id     = data.azurerm_subnet.this.id
#       size          = "Standard_D8s_v5"
#       image_id      = data.azurerm_image.hana.id
#       hana_sid      = "t01"
#       zone          = "1"
#       disks = {
#         # usr sap
#         sdb = {
#           name                 = "-usr_sap"
#           size                 = 64
#           lun                  = 0
#           caching              = "None"
#           storage_account_type = "Premium_LRS"
#         }
#         # hana shared
#         sdc = {
#           name                 = "-hana_shared"
#           size                 = 64
#           lun                  = 1
#           caching              = "None"
#           storage_account_type = "Premium_LRS"
#         }
#         # data
#         sdd = {
#           name                 = "-hana_data_01"
#           size                 = 128
#           lun                  = 2
#           caching              = "None"
#           storage_account_type = "Premium_LRS"
#         }
#         # # data
#         # sde = {
#         #   name                 = "-hana_data_02"
#         #   size                 = 128
#         #   lun                  = 3
#         #   caching              = "None"
#         #   storage_account_type = "Premium_LRS"
#         # }
#         # # data
#         # sdf = {
#         #   name                 = "-hana_data_03"
#         #   size                 = 128
#         #   lun                  = 4
#         #   caching              = "None"
#         #   storage_account_type = "Premium_LRS"
#         # }
#         # # data
#         # sdg = {
#         #   name                 = "-hana_data_04"
#         #   size                 = 128
#         #   lun                  = 5
#         #   caching              = "None"
#         #   storage_account_type = "Premium_LRS"
#         # }
#         # # log
#         sde = {
#           name                 = "-hana_log_01"
#           size                 = 64
#           lun                  = 6
#           caching              = "None"
#           storage_account_type = "Premium_LRS"
#         }
#         # # log
#         # sdi = {
#         #   name                 = "-hana_log_02"
#         #   size                 = 64
#         #   lun                  = 7
#         #   caching              = "None"
#         #   storage_account_type = "Premium_LRS"
#         # }
#         # # log
#         # sdj = {
#         #   name                 = "-hana_log_03"
#         #   size                 = 64
#         #   lun                  = 8
#         #   caching              = "None"
#         #   storage_account_type = "Premium_LRS"
#         # }
#         # # log
#         # sdk = {
#         #   name                 = "-hana_log_04"
#         #   size                 = 64
#         #   lun                  = 9
#         #   caching              = "None"
#         #   storage_account_type = "Premium_LRS"
#         # }
#         # # log
#         # sdl = {
#         #   name                 = "-hana_log_05"
#         #   size                 = 64
#         #   lun                  = 10
#         #   caching              = "None"
#         #   storage_account_type = "Premium_LRS"
#         # }
#       }
#     }
#   }
# }
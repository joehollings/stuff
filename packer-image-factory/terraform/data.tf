# # credential 
# data "azurerm_key_vault" "this" {
#   name                = local.key_vault_name
#   resource_group_name = local.key_vault_resource_group_name
# }

# data "azurerm_key_vault_secret" "local_admin_password" {
#   name         = local.admin_password_secret_name
#   key_vault_id = data.azurerm_key_vault.this.id
# }

# data "azurerm_key_vault_secret" "ad_admin_password" {
#   name         = local.ad_admin_password_secret_name
#   key_vault_id = data.azurerm_key_vault.this.id
# }

# data "azurerm_key_vault_secret" "suse_reg_code" {
#   name         = local.suse_reg_code
#   key_vault_id = data.azurerm_key_vault.this.id
# }

# # vnet data sources
# data "azurerm_virtual_network" "this" {
#   name                = local.vnet_name
#   resource_group_name = local.vnet_rsg_name
# }

# data "azurerm_subnet" "this" {
#   name                 = local.subnet_name
#   virtual_network_name = data.azurerm_virtual_network.this.name
#   resource_group_name  = data.azurerm_virtual_network.this.resource_group_name
# }

# # image data sources
# data "azurerm_image" "bpc" {
#   name                = "svr2022bpc"
#   resource_group_name = "packer-rsg-prod"
# }

# data "azurerm_image" "vda2013" {
#   name                = "win10o2013ao"
#   resource_group_name = "packer-rsg-prod"
# }

# data "azurerm_image" "vda2019" {
#   name                = "win10o2019ao"
#   resource_group_name = "packer-rsg-prod"
# }

# data "azurerm_image" "hana" {
#   name                = "sles15sp3"
#   resource_group_name = "packer-rsg-prod"
# }

# data "azurerm_image" "dc_cc" {
#   name                = "svr2022"
#   resource_group_name = "packer-rsg-prod"
# }

# data "azurerm_image" "vda2019epm" {
#   name                = "win10o2019epm"
#   resource_group_name = "packer-rsg-prod"
# }

# data "azurerm_image" "vda2019epmtest" {
#   name                = "win10o2019epmtest"
#   resource_group_name = "packer-rsg-prod"
# }

# # data "azurerm_image" "win1022h2rsat" {
# #   name                = "win1022h2rsat"
# #   resource_group_name = "packer-rsg-prod"
# # }

# data "azurerm_image" "win10win1022h2" {
#   name                = "win10win1022h2"
#   resource_group_name = "packer-rsg-prod"
# }

# module "windows" {
#   source                       = "github.com/OpalwaveSolutions/terraform-azure-windows-vda?ref=v1.1.2"
#   for_each                     = local.windows
#   name                         = each.value.name
#   computer_name                = each.value.computer_name
#   resource_group_name          = data.azurerm_virtual_network.this.resource_group_name
#   location                     = local.location
#   subnet_name                  = data.azurerm_subnet.this.name
#   subnet_id                    = data.azurerm_subnet.this.id
#   zone                         = each.value.zone
#   size                         = each.value.size
#   source_image_id              = each.value.image_id
#   admin_username               = local.admin_username
#   admin_password               = data.azurerm_key_vault_secret.local_admin_password.value
#   active_directory_domain_name = "owscs.local"
#   ad_admin_password            = data.azurerm_key_vault_secret.ad_admin_password.value
#   ad_admin_username            = "joe.hollings.adm"
#   tags_customer                = local.customer_name
#   tags_environment             = local.environment
#   tags_patching                = "none"
#   tags_project                 = local.project
# }

# module "linux" {
#   source                       = "github.com/OpalwaveSolutions/terraform-azure-linux-hana?ref=v1.3.2"
#   for_each                     = local.linux
#   resource_group_name          = data.azurerm_virtual_network.this.resource_group_name
#   location                     = local.location
#   computer_name                = each.value.computer_name
#   subnet_name                  = data.azurerm_subnet.this.name
#   subnet_id                    = data.azurerm_subnet.this.id
#   size                         = each.value.size
#   zone                         = each.value.zone
#   proximity_placement_group_id = azurerm_proximity_placement_group.test.id
#   source_image_id              = each.value.image_id
#   admin_user                   = local.admin_username
#   admin_password               = data.azurerm_key_vault_secret.local_admin_password.value
#   hana_sid                     = each.value.hana_sid
#   reg_code                     = data.azurerm_key_vault_secret.suse_reg_code.value
#   managed_disk                 = lookup(each.value, "disks", {})
#   tags_customer                = local.customer_name
#   tags_environment             = local.environment
#   tags_project                 = local.project
# }

# resource "azurerm_proximity_placement_group" "test" {
#   name                = "owscs-suse-test"
#   location            = local.location
#   resource_group_name = data.azurerm_virtual_network.this.resource_group_name
# }
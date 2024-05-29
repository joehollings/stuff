# resource "azurerm_proximity_placement_group" "test" {
#   name                = "owscs-ppg-asl-test"
#   location            = data.azurerm_resource_group.prod.location
#   resource_group_name = data.azurerm_resource_group.prod.name

#   tags = {
#     environment = "Test"
#     customer    = local.customer_name
#     project     = "00000"
#   }
# }

# module "hana" {
#   source                       = "github.com/OpalwaveSolutions/terraform-azure-linux-hana?ref=v1.3.2"
#   for_each                     = local.hana
#   location                     = data.azurerm_resource_group.prod.location
#   resource_group_name          = data.azurerm_resource_group.prod.name
#   computer_name                = "az${local.customer_number}${each.value.hana_sid}hdb01"
#   subnet_id                    = data.azurerm_subnet.snet-db-prod.id
#   subnet_name                  = data.azurerm_subnet.snet-db-prod.name
#   size                         = each.value.size
#   zone                         = each.value.zone
#   proximity_placement_group_id = each.value.proximity_placement_group_id
#   source_image_id              = data.azurerm_image.hana.id
#   admin_user                   = local.admin_username
#   admin_password               = data.azurerm_key_vault_secret.local_admin_password.value
#   hana_sid                     = each.value.hana_sid
#   reg_code                     = data.azurerm_key_vault_secret.suse_reg_code.value
#   managed_disk                 = lookup(each.value, "disks", {})
#   tags_customer                = local.customer_name
#   tags_environment             = each.key
#   tags_project                 = "00${local.customer_number}"
# }
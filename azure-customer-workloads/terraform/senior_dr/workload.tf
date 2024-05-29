# module "hana" {
#   source                       = "github.com/OpalwaveSolutions/terraform-azure-linux-hana?ref=v1.3.2"
#   for_each                     = local.hana
#   resource_group_name          = "10110-rsg-prod"
#   location                     = "uk south"
#   computer_name                = "az${local.customer_number}${each.value.hana_sid}hdbdr"
#   subnet_id                    = data.azurerm_subnet.snet-db-prod.id
#   subnet_name                  = data.azurerm_subnet.snet-db-prod.name
#   size                         = each.value.size
#   zone                         = each.value.zone
#   proximity_placement_group_id = each.value.proximity_placement_group_id
#   source_image_id              = data.azurerm_image.hana.id
#   admin_user                   = local.admin_username
#   admin_password               = data.azurerm_key_vault_secret.local_admin_password.value
#   hana_sid                     = each.value.hana_sid
#   managed_disk                 = lookup(each.value, "disks", {})
#   tags_customer                = local.customer_name
#   tags_environment             = each.key
#   tags_project                 = "10${local.customer_number}"
# }
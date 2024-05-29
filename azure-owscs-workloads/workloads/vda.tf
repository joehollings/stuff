module "vda" {
  source                       = "github.com/OpalwaveSolutions/terraform-azure-windows-vda?ref=v1.1.2"
  for_each                     = local.vda
  name                         = "azcsvda${each.key}template"
  computer_name                = "azcsvda${each.key}"
  resource_group_name          = data.azurerm_resource_group.prod.name
  location                     = data.azurerm_resource_group.prod.location
  subnet_name                  = each.value.subnet_name
  subnet_id                    = each.value.subnet_id
  zone                         = each.value.zone
  size                         = each.value.size
  source_image_id              = each.value.image_id
  admin_username               = "owscs-admin"
  admin_password               = data.azurerm_key_vault_secret.local_admin_password.value
  active_directory_domain_name = "owscs.local"
  ad_admin_password            = data.azurerm_key_vault_secret.ad_admin_password.value
  ad_admin_username            = local.ad_admin_username
  tags_customer                = "owscs"
  tags_environment             = "Prod"
  tags_patching                = "Templates"
  tags_project                 = "00000"
}

locals {
  ad_admin_username             = "joe.hollings.adm"
  ad_admin_password_secret_name = "OWSCS-Joe-ADM"
  vda = {
    inf = {
      zone        = "2"
      size        = "Standard_D2s_v5"
      subnet_name = data.azurerm_subnet.snet-sharedresources.name
      subnet_id   = data.azurerm_subnet.snet-sharedresources.id
      image_id    = data.azurerm_image.win1022h2rsat.id
    }
  }
}
# credential 
data "azurerm_key_vault" "this" {
  name                = local.key_vault_name
  resource_group_name = local.key_vault_resource_group_name
}

data "azurerm_key_vault_secret" "local_admin_password" {
  name         = local.admin_password_secret_name
  key_vault_id = data.azurerm_key_vault.this.id
}

data "azurerm_key_vault_secret" "ad_admin_password" {
  name         = local.ad_admin_password_secret_name
  key_vault_id = data.azurerm_key_vault.this.id
}

# infrastructure data sources
data "azurerm_resource_group" "hub-rsg-prod" {
  name = local.key_vault_resource_group_name
}

data "azurerm_virtual_network" "vnet-hub" {
  name                = local.hub_vnet_name
  resource_group_name = data.azurerm_resource_group.hub-rsg-prod.name
}

data "azurerm_subnet" "snet-identityservices" {
  name                 = local.hub_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet-hub.name
  resource_group_name  = data.azurerm_resource_group.hub-rsg-prod.name
}

data "azurerm_proximity_placement_group" "dev" {
  name                = "10${local.customer_number}-ppg-sap-dev"
  resource_group_name = azurerm_resource_group.prod.name
}

# data "azurerm_proximity_placement_group" "qas" {
#   name                = "10${local.customer_number}-ppg-sap-qas"
#   resource_group_name = azurerm_resource_group.prod.name
# }

data "azurerm_proximity_placement_group" "prod" {
  name                = "10${local.customer_number}-ppg-sap-prod"
  resource_group_name = azurerm_resource_group.prod.name
}
#vnet data sources
data "azurerm_virtual_network" "this" {
  name                = "10${local.customer_number}-vnet-app-prod"
  resource_group_name = azurerm_resource_group.prod.name
}

data "azurerm_subnet" "snet-presentation-prod" {
  name                 = "snet-presentation-prod"
  virtual_network_name = data.azurerm_virtual_network.this.name
  resource_group_name  = azurerm_resource_group.prod.name
}

data "azurerm_subnet" "snet-dev-test-prod" {
  name                 = "snet-dev-test-prod"
  virtual_network_name = data.azurerm_virtual_network.this.name
  resource_group_name  = azurerm_resource_group.prod.name
}

data "azurerm_subnet" "snet-sap-prod" {
  name                 = "snet-sap-prod"
  virtual_network_name = data.azurerm_virtual_network.this.name
  resource_group_name  = azurerm_resource_group.prod.name
}

data "azurerm_subnet" "snet-db-prod" {
  name                 = "snet-db-prod"
  virtual_network_name = data.azurerm_virtual_network.this.name
  resource_group_name  = azurerm_resource_group.prod.name
}
# virtual machine data sources
data "azurerm_virtual_machine" "dc01" {
  name                = "az${local.customer_number}wdc01"
  resource_group_name = azurerm_resource_group.prod.name
}

data "azurerm_virtual_machine" "dc02" {
  name                = "az${local.customer_number}wdc02"
  resource_group_name = azurerm_resource_group.prod.name
}

data "azurerm_virtual_machine" "cc01" {
  name                = "az${local.customer_number}ccc01"
  resource_group_name = azurerm_resource_group.prod.name
}

data "azurerm_virtual_machine" "cc02" {
  name                = "az${local.customer_number}ccc02"
  resource_group_name = azurerm_resource_group.prod.name
}

# image data sources
data "azurerm_image" "bpc" {
  name                = "svr2022bpc"
  resource_group_name = "packer-rsg-prod"
}

data "azurerm_image" "vda" {
  name                = "win10o2013ao"
  resource_group_name = "packer-rsg-prod"
}

# data "azurerm_image" "vda2019epm" {
#   name                = "win10o2019epm"
#   resource_group_name = "packer-rsg-prod"
# }

data "azurerm_image" "vda2019ao" {
  name                = "win10o2019ao"
  resource_group_name = "packer-rsg-prod"
}

data "azurerm_image" "hana" {
  name                = "sles15sp3"
  resource_group_name = "packer-rsg-prod"
}

# image data sources
data "azurerm_image" "dc_cc" {
  name                = "svr2022"
  resource_group_name = "packer-rsg-prod"
}
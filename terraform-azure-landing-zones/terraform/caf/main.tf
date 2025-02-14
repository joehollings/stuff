# Obtain client configuration from the un-aliased provider
data "azurerm_client_config" "core" {
  provider = azurerm
}

# Obtain client configuration from the "management" provider
data "azurerm_client_config" "management" {
  provider = azurerm.management
}

# Obtain client configuration from the "connectivity" provider
data "azurerm_client_config" "connectivity" {
  provider = azurerm.connectivity
}

# Map each module provider to their corresponding `azurerm` provider using the providers input object
module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "6.1.0" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

  providers = {
    azurerm              = azurerm
    azurerm.management   = azurerm.management
    azurerm.connectivity = azurerm.connectivity
  }

  default_location = "uksouth"

  # Set the required input variable `root_parent_id` using the Tenant ID from the un-aliased provider
  root_parent_id = data.azurerm_client_config.core.tenant_id
  root_id        = var.root_id
  root_name      = var.root_name

  # Enable deployment of the management resources, using the management
  # aliased provider to populate the correct Subscription ID
  deploy_management_resources    = false
  subscription_id_management     = data.azurerm_client_config.management.subscription_id
  configure_management_resources = local.configure_management_resources

  # Enable deployment of the connectivity resources, using the connectivity
  # aliased provider to populate the correct Subscription ID
  deploy_connectivity_resources    = false
  subscription_id_connectivity     = data.azurerm_client_config.connectivity.subscription_id
  configure_connectivity_resources = local.configure_connectivity_resources

  # insert additional optional input variables here
  deploy_identity_resources = false
  subscription_id_identity  = var.subscription_id_identity
  # overrides policy enforcement
  archetype_config_overrides = local.archetype_config_overrides
}
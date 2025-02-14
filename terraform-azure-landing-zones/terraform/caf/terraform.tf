terraform {
  required_version = ">=1.9.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.19.0"
      configuration_aliases = [
        azurerm.connectivity,
        azurerm.management,
      ]
    }
  }
  backend "azurerm" {
    resource_group_name  = "rsg-storage-test"
    storage_account_name = "afskabtest"
    container_name       = "tfstates"
    subscription_id      = "4aad00f0-c628-4582-802c-fb2033451972"
    # Use Landing Zone subscription ID as key name
    key = "caf.tfstate"
    # use_oidc         = true
    # use_azuread_auth = true
  }
}

provider "azurerm" {
  features {}
}

# Declare an aliased provider block using your preferred configuration.
# This will be used for the deployment of all "Connectivity resources" to the specified `subscription_id`.

provider "azurerm" {
  alias           = "connectivity"
  subscription_id = "ab545a1d-96bb-41f7-a3a6-90c386081229"
  features {}
}

# Declare a standard provider block using your preferred configuration.
# This will be used for the deployment of all "Management resources" to the specified `subscription_id`.

provider "azurerm" {
  alias           = "management"
  subscription_id = "dccfeece-2566-44c7-a323-05b4ce7d6935"
  features {}
}

terraform {
  required_version = ">=1.9.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.19.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rsg-storage-test"
    storage_account_name = "afskabtest"
    container_name       = "tfstates"
    subscription_id      = "4aad00f0-c628-4582-802c-fb2033451972"
    # Use Landing Zone subscription ID as key name
    key = "connectivity.tfstate"
    # use_oidc         = true
    # use_azuread_auth = true
  }
}

# Configure the Microsoft Azure Provider for Landing Zone Subscription
provider "azurerm" {
  features {}
  # Landing Zone Subscription ID
  subscription_id = "ab545a1d-96bb-41f7-a3a6-90c386081229"
}
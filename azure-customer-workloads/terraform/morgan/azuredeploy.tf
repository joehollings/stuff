# Change key to customer number ie 10000.tfstate
terraform {
  backend "azurerm" {
    resource_group_name  = "owscs-rsg-hub"
    storage_account_name = "owscsafs02"
    container_name       = "tfstates"
    key                  = "10011.tfstate"
  }
}
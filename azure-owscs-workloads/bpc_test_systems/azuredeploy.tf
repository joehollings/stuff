# Change key to branch name ie branchname.tfstate
terraform {
  backend "azurerm" {
    resource_group_name  = "owscs-rsg-hub"
    storage_account_name = "owscsafs02"
    container_name       = "tfstates"
    key                  = "bpc_test_systems.tfstate"
  }
}
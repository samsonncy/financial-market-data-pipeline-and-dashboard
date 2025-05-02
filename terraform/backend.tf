terraform {
  backend "azurerm" {
    resource_group_name  = "infra-rg"
    storage_account_name = "infratfstate2"
    container_name       = "tfstate-container"
    key                  = "fmdp/terraform.tfstate"
  }
}
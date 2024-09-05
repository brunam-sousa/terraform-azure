#configure de azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.112.0"
    }
  }
  required_version = ">=1.8.0"
}

# provider is a plugin that Terraform uses to create and manage your resource
# is possible define multiple provider blocks 
provider "azurerm" {
  features {}
}
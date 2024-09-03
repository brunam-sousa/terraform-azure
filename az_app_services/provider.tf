# By separating the provider configuration 
# from the main configuration files, we centralize
# the provider configuration and reduce duplication

#configure de azure provider
terraform {            # this block contains Terraform Settings
  required_providers { # providers are installed from Terraform Registry
    azurerm = {
      source  = "hashicorp/azurerm" # shorthand for registry.terraform.io/hashicorp/azurerm
      version = ">=3.112.0"         # without, terraform assume the latest version
    }
  }
  required_version = ">=1.8.0"
}

# provider is a plugin that Terraform uses to create and manage your resource
# is possible define multiple provider blocks 
provider "azurerm" {
  features {}
}
#configure de azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.112.0"
    }
  }

backend "azurerm" {
  resource_group_name = "RG_remotestate"
  storage_account_name = "<storage account name>"
  container_name = "tfstate"
  key = "0.storageaccount.terraform.tfstate" # name of the state store file to be created
  # access_key: The storage access key. 
  # Is recommended that this value be stored  in a environment variable:
  # ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
  # export ARM_ACCESS_KEY=$ACCOUNT_KEY
  # In a production deployment, it's recommended to evaluate to  Azure Active Directory or  SAS Token to authenticating to the storage account 
  }
}


# provider is a plugin that Terraform uses to create and manage your resource
# is possible define multiple provider blocks 
provider "azurerm" {
  features {}
}
resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tfstate" {
  name     = "RG_remotestate"
  location = "southeastasia"
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstate${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob" # can be blob, container or private
}

# Use this data source to access information about an existing Storage Account.
data "azurerm_storage_account" "storage" {
  name                = azurerm_storage_account.tfstate.name
  resource_group_name = azurerm_resource_group.rg.name
}

# after the succesfully apply, terraform wil show the name of the storage account
output "storage_account_name" {
  value = azurerm_storage_account.tfstate.name
}
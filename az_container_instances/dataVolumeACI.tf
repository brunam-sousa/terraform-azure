# by default ACI containers dont have any data volumes attached, are stateless
# data volumes are mounted to retain data
# To mount a data volume to our ACI:
# > create a storage account (need to be unique)
# > create a storage share
# > mount a volume (main.tf)


##################################
# AZURE STORAGE ACCOUNT BLOCK
##################################
resource "azurerm_storage_account" "storageact" {
  name = "stgChapt4"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  account_tier = "Standard"
  account_replication_type = "LRS"

}

##################################
# AZURE FILE SHARE BLOCK
# just act as a logical unit for storage
# this code create a file share with 50GB storage quote
##################################
resource "azurerm_storage_share" "share" {
  name = "acishare"
  storage_account_name = azurerm_storage_account.storageact.name
  quota = 50
}
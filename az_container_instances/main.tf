# ACI run Docker containers on-demand in a managed, serverless Azure environment in a Hypervisor-level security
# Azure Container Instances is useful for scenarios that can operate in 
# isolated containers (without need of orchestration), 
# including simple applications, task automation, and build jobs


# > create an ACI container
# > conect AZ Container Registry to an ACI Container
# > mount data volume using Az File Share
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "myResourceGroup"
  location = "eastus"
}

##################################
# AZURE CONTAINER INSTANCE BLOCK
# The following code creates a Linux ACI with two CPUs
# open port 80 for incoming traffic from the internet. 
##################################

resource "azurerm_container_group" "acigroup" {
  name = "chap4ACI"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type = "Public"
  dns_name_label = "azterraformaci"
  os_type = "Linux"

# handle with ACR authentication 
  image_registry_credential {
    server = var.acrserver
    username = var.acruser
    password = var.acrpassword
  }

  # if this block is repeating, so we had a multi ACI container  
  container {
    name = "web-server"
    image = var.acrimage
    cpu = "2"
    memory = "4"

    ports {
      port = 80
      protocol = "TCP"
    }
    # By default, Azure Container Instances are stateless
    # Volume mounting: Azure Files (emptyDir, GitRepo and secret are Linux only)
    # Persistent storage: Mount Azure Files shares directly to a container to retrieve and persist state.
    # mount the data volume to ACI container and set the parameters
    # To mount an Azure file share as a volume in Azure Container Instances, you need these three values:
    # > Storage account name
    # > Share name
    # > Storage account access key
    volume {
      name = "logs"
      mount_path = "/chap04/logs"
      read_only = false
      share_name = azurerm_storage_share.share.name
      storage_account_key = azurerm_storage_account.storageact.primary_access_key
      storage_account_name = azurerm_storage_account.storageact.name
    }
  }

  tags = {
    environment = "dev"
  }
}
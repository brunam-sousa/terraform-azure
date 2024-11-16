resource "azurerm_resource_group" "rg" {
  name     = "RG_aks_cluster"
  location = "south india"
}

resource "azurerm_kubernetes_cluster" "akscluster" {
  name                = "RG_aks_cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aks"
  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = "Standard_D2_v2" # 2 vCPUs and 7GB memory
  }
  # identity or service principal block could be used
  identity {
    # define the TYPE of Managed Service Identity used on the CLUSTER: systemAssigned or Userassigned
    type = "SystemAssigned"
  }
  tags = {
    Environment = "DEV"
  }
}

################################
# Azure Container Registry Block
################################

resource "azurerm_container_registry" "acr" {
  name                = "acrTempBruna"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Premium"
  admin_enabled       = true
}

resource "terraform_data" "acrbuild" {
  provisioner "local-exec" {
    command = "az acr build -r ${azurerm_container_registry.acr.name} --image devox:v2 -f /home/bruna/devox_project/Dockerfile /home/bruna/devox_project"
  }
}

# Assigns a given Principal (User or Group) to a given Role
# Establishes an authentication mechanism with AKS
resource "azurerm_role_assignment" "aksrole" {
  # The ID of the Principal (User, Group or Service Principal) to assign the Role Definition to
  # The Principal ID is also known as the Object ID (ie not the "Application ID" for applications)
  principal_id = azurerm_kubernetes_cluster.akscluster.kubelet_identity[0].object_id
  # a list of built in roles names and ids: https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
  role_definition_name             = "AcrPull"                         # AcrPull is that permite pull artifacts from a container registry
  scope                            = azurerm_container_registry.acr.id # The scope at which the Role Assignment applies to 
  skip_service_principal_aad_check = true
}
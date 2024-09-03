# Private endpoints only allow access to web apps from
# private networks and block access to them by general
# users on the internet

# Private endpoints allow access to web apps from on-premises 
#networks only or from Azure private networks.

# To configure a private endpoint, we must create a Vnet and
# place the web app inside the network within the internal 
# network interface controller (NIC).

# Resources used in Terraform to deploy a private endpoint:
# > Azure Virtual Network
# > Azure Subnet
# > Virtual Network connectivity
# > Private DNS zone (necessary to access a private endpoint from a Vnet)
# > Private Endpont


##################################
# VNET BLOCK 
##################################
resource "azurerm_virtual_network" "azvnet" {
  name                = "VnetWebApp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

##################################
# SUBNET BLOCK 
##################################
resource "azurerm_subnet" "webappsubnet" {
  name                 = "webappsubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.azvnet.name
  address_prefixes     = ["10.0.1.0/24"]
  # When you delegate a subnet to an Azure service, you allow
  # that service to establish some basic network configuration
  # rules for that subnet, which help the Azure service operate
  # their instances in a stable manner.

  # Designa uma sub-rede específica para um serviço PaaS do Azure
  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_subnet" "privatesubnet" {
  name                              = "privatesubnet"
  resource_group_name               = azurerm_resource_group.rg.name
  virtual_network_name              = azurerm_virtual_network.azvnet.name
  address_prefixes                  = ["10.0.2.0/24"]
  private_endpoint_network_policies = "Enabled"
}

##################################
# RESOURCE GROUP BLOCK
# resource block define components of your infra
# resource type = azure_resource_group
# resource name = rg
# resource type and name form a unique ID for the resource: azurerm_resource_group.rg
##################################
resource "azurerm_resource_group" "rg" {
  name     = "myResourceGroup"
  location = "eastus"
}

##################################
# LINUX SERVICE PLAN BLOCK
# App service always runs in an App Service plan
# App Service plan defines a set of compute resources for a web app to run
# sku_name = F1 is a free tier (no cost, no scale out)
##################################
resource "azurerm_service_plan" "appservice" {
  name                = "Linux"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

##################################
# LINUX WEB APP BLOCK 
##################################
resource "azurerm_linux_web_app" "webapp" {
  name                = "DevoxWebapp${random_integer.rd.result}" # using variable interpolation 
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.appservice.id
  https_only          = "true"
  site_config {
    always_on           = "false" # always_on cannot be set to true when using Free, F1, D1 Sku
    minimum_tls_version = "1.2"
    application_stack {
      docker_image_name = var.acr_image
      docker_registry_url = var.acr_server
      docker_registry_username =  var.acr_user
      docker_registry_password = var.acr_password
    }
    #ip_restriction {
    #  ip_address = "10.0.0.0/24"
    #  action = "Allow"
    #}
  }
  app_settings = { # A map of key-value pairs of App Settings
    # app settings are variables passed as environment variables to the application code
    # For Linux apps and containers, the setting are passed using --env flag
    # app settings are injected into the app environment at app startup and add/remove/edit trigger an app restart
    # app setting reference: https://learn.microsoft.com/en-us/azure/app-service/reference-app-settings?tabs=kudu%2Cdotnet
    "DOCKER_ENABLE_CI"     = "true" # enable the continuous deployment for custom containers. (default: false )
    vnet_route_all_enabled = "true"
  }
}

# generate a random int that will be used to name the web app
resource "random_integer" "rd" {
  min = 1
  max = 20
}

#resource "azurerm_app_service_virtual_network_swift_connection" "vnetintegrationconnection" {
#app_service_id = azurerm_linux_web_app.webapp.id
#subnet_id      = azurerm_subnet.webappsubnet.id
#}
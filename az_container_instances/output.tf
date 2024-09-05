# file used to check the success of deployment and display:
# > FQDN
# > resource ID
# > public IP
# > availability zone
# > tags

# the data resource is used because the values are not in the configuration
data "azurerm_container_group" "acigroup" {
  name                = azurerm_container_group.acigroup.name
  resource_group_name = azurerm_resource_group.rg.name
}

output "fqdn" {
  value = data.azurerm_container_group.acigroup.fqdn
}

output "id" {
  value = data.azurerm_container_group.acigroup.id
}

output "ip" {
  value = data.azurerm_container_group.acigroup.ip_address
}

output "zones" {
  value = data.azurerm_container_group.acigroup.zones
}

output "tags" {
  value = data.azurerm_container_group.acigroup.tags
}
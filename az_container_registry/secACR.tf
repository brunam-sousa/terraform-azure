# this file will deploy some security features to our ACR:
# 1. Azure Key Vault with standard tier
# 2. Key Vault access policy
# 3. Azure AD service principal account
# 4. Enabling of ACR encryption
# 5. Enabling of soft delete with seven days’ retention
# 6. Purge protection
# 7. Enabling of disk encryption


# read the Azure client information to retrieve tenantId
data "azurerm_client_config" "current" {}

##########################
# AZURE KEY VAULT BLOCK
# create an Azure Key Vault used to store the encryption key:
# >> Enable Disk encryption
# >> Enable soft Delete
# >> Disable purge protection
# >> Premium SKU
###########################
resource "azurerm_key_vault" "azvault" {
  name                        = "kvChap03"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  # Authentication is always performed by associating the request with the Microsoft Entra tenant of the subscription that the Key Vault is part of
  tenant_id                  = data.azurerm_client_config.current.tenant_id # tenant ID that should be used for authenticating requests to the key vault.
  soft_delete_retention_days = 7                                            # the ability to turn off this option has been deprecated in Azure
  purge_protection_enabled   = false                                        # dont enforce a mandatory retention period for deleted vaults and vault objects
  sku_name                   = "standard"

  # To access a key vault all callers (users or applications) must have proper authentication and authorization
  # the permission model can be RBAC (recommended) or Key Vault Access Policy
  # object_id defines who is attached in the rule
  # here we are defining de accesses of the user that is logged in and executing the terraform configurations
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id # object ID of a user, service principal or security group
    key_permissions = [
      "List",
      "Get",
      "Create",
      "Delete",
      "Purge",
      "Recover",
      "Update",
      "GetRotationPolicy",
      "SetRotationPolicy",
      "WrapKey",
      "UnwrapKey"
    ]
    secret_permissions = [
      "List",
      "Get",
      "Set"
    ]
    storage_permissions = [
      "List",
      "Get",
      "Set"
    ]
  }
}

# create a user assigned identity used to manage ACR encryption
# and interaction with Azure Key Vault
# username: acr-admin
resource "azurerm_user_assigned_identity" "mgdIdentity" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "acr-admin"
}

data "azurerm_user_assigned_identity" "dataIdentity" {
  resource_group_name = azurerm_resource_group.rg.name
  name                = "acr-admin"
  depends_on          = [azurerm_user_assigned_identity.mgdIdentity] # without this we had a error: 'acr-admin was not found'
}

###########################
# SERVICE PRINCIPAL BLOCK
# Service Principal: identifies an app or service:
# >> service principal object ID: 
# >> service principal Client ID:
# >> service principal client secret or certificate (acts like password)
###########################
/*data "azuread_service_principal" "serviceprincipal" {
  # The display name of the application associated with this service principal.
  # we’re looking up the service principal ID of an identity object called acr-admin (a user assigned identity below)
  display_name = "acr-admin"
}*/


##########################
# AZURE KEY VAULT ACCESS POLICY BLOCK
# policy to be used for the User Assigned Identity acr-admin
# accounts access to the vault with the permissions listed under key_permissions
# object_id: User Assigned Identity acr-admin id
# permissions only to deal with keys 
###########################
resource "azurerm_key_vault_access_policy" "accesspolManagedIdentity" {
  key_vault_id = azurerm_key_vault.azvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  #object_id    = data.azuread_service_principal.serviceprincipal.object_id # give a service principal account access to the vault with the permissions listed under key_permissions
  object_id = data.azurerm_user_assigned_identity.dataIdentity.principal_id
  key_permissions = [
    "List",
    "Get",
    "Create",
    "Delete",
    "Purge",
    "Recover",
    "Update",
    "GetRotationPolicy",
    "SetRotationPolicy",
    "WrapKey",
    "UnwrapKey"
  ]
}

data "azurerm_key_vault" "azvault" {
  name                = azurerm_key_vault.azvault.name
  resource_group_name = azurerm_resource_group.rg.name
}

##########################
# CREATE A KEY BLOCK
# create a key used to encrypt data
# define what kind of operations are allowed with the key rotation policy
###########################
resource "azurerm_key_vault_key" "acrkey" {
  name         = "acrKey"
  key_vault_id = azurerm_key_vault.azvault.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
    "unwrapKey"
  ]

  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }

    expire_after         = "P90D"
    notify_before_expiry = "P29D"
  }
}

# Use this data source to access information about an existing Key Vault Key
# key_vault_id: Specifies the ID of the Key Vault instance where the Secret resides, available on the azurerm_key_vault Data Source / Resource.
data "azurerm_key_vault_key" "readkey" {
  name         = azurerm_key_vault_key.acrkey.name
  key_vault_id = data.azurerm_key_vault.azvault.id
}
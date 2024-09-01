resource "azurerm_resource_group" "rg" {
  name     = "myResourceGroup"
  location = "eastus"
}

resource "azurerm_container_registry" "acr" {
  name                = "acrTempBruna"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Premium"
  admin_enabled       = true
  tags = {
    environment = "dev"
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.mgdIdentity.id
    ]
  }

  encryption {
    # enabled            = true # unsuported argument 
    key_vault_key_id   = data.azurerm_key_vault_key.readkey.id
    identity_client_id = azurerm_user_assigned_identity.mgdIdentity.client_id
  }

  # georeplication, so that it serves multiple regions using a single ACR registry
  # this configuration is optional 
  # georeplications {
  #    location                = "Australia Central"
  #    zone_redundancy_enabled = false
  #    tags                    = {}
  #  }

}


resource "terraform_data" "acrbuild" {
  provisioner "local-exec" {
    command = "az acr build -r ${azurerm_container_registry.acr.name} --image devox:v2 -f /home/bruna/devox_project/Dockerfile /home/bruna/devox_project"
  }
}

/*
resource "azurerm_container_registry_task" "example" {
  name                  = "example-2"
  container_registry_id = azurerm_container_registry.acr.id

  platform {
    os = "Linux"
  }

  docker_step {
    dockerfile_path      = "Dockerfile"
    context_path         = "/home/bruna/devox_project"
    context_access_token = "None"
    image_names          = ["helloworld:{{.Run.ID}}"]
  }

  base_image_trigger {
    name = "defaultBaseTrigger"
    type = "All"
    enabled = false
  }

resource "azurerm_container_registry_task_schedule_run_now" "example" {
  container_registry_task_id = azurerm_container_registry_task.example.id
}
*/
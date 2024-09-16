# variables used to access the ACR configured in az_container_registry directory
variable "acrimage" {
  type    = string
  default = "devox:v2"
}

variable "acruser" {
  type    = string
  default = "acrtempbruna"
}

variable "acrserver" {
  type    = string
  default = "acrtempbruna.azurecr.io"
}

# $ terraform apply -var="acrpassword= ACR PASSWORD"
variable "acrpassword" {
  type = string
}

variable "resourceGroup_id" {
  description = "Id of resource group previously created"
  type        = string
  sensitive   = true
}

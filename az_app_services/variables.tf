# The file is called variables.tf; 
# the name of this file no matter, as Terraform doesn’t care about 
#  file to store the details of our ACR

variable "acr_image" {
  type    = string
  default = "devox:v2"
}

variable "acr_user" {
  type    = string
  default = "acrtempbruna"
}

variable "acr_server" {
  type    = string
  default = "https://acrtempbruna.azurecr.io"
}

# We’ll pass the password as a parameter using the command line
# The following Terraform apply command will deploy the code and pass the password to Azure:
# $ terraform apply -var="acrpassword= ACR PASSWORD"
variable "acr_password" {
  type = string
}
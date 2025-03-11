variable "acr_username" {
  description = "El usuario del Azure Container Registry"
  type        = string
}

variable "acr_password" {
  description = "La contraseña del Azure Container Registry"
  type        = string
  sensitive   = true  # Oculta el valor en la salida de Terraform
}

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

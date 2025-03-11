terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.18.0"
    }
  }
}

provider "azurerm" {
  features {}
  use_msi         = true
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secre
  tenant_id       = var.tenant_id
}

resource "azurerm_resource_group" "AndresDocker" {
  name     = "AndresDocker"
  location = "eastus"
}

resource "azurerm_container_group" "tf_cg_IAC_abeltran" {
  name                = "cg-IACabelt"
  location            = azurerm_resource_group.AndresDocker.location
  resource_group_name = azurerm_resource_group.AndresDocker.name
  ip_address_type     = "Public"
  os_type             = "Linux"

  dns_name_label = "abeltran-iac-container"

  container {
    name   = "iacabortiz"
    image  = "myacrrregistry.azurecr.io/abeltran12/iac"
    cpu    = 1.0
    memory = 1.0

    ports {
      port     = 8080
      protocol = "TCP"
    }
  }

  image_registry_credential {
    server   = "myacrrregistry.azurecr.io"
    username = var.acr_username
    password = var.acr_word
  }
}
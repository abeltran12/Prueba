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
  subscription_id = "ef9c2453-b11a-4ba2-8495-012c166910d2"
  client_id       = "d4401217-8d22-4771-8963-9006d0b362f2"
  client_secret   = "-dP8Q~b9RU2tyMkwIG2S.xLmq~eYspI6ynzDEa-0"
  tenant_id       = "e37b53b0-215c-48b7-ad84-69a26c44f71d"
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
    username = "d4401217-8d22-4771-8963-9006d0b362f2"  # ID del Service Principal
    password = "-dP8Q~b9RU2tyMkwIG2S.xLmq~eYspI6ynzDEa-0"  # Secret del Service Principal
  }
}
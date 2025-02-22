# terraform/main.tf
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_group" "web_server" {
  name                = "my-web-server"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "Public"
  os_type             = "Linux"

  container {
    name   = "backend"
    image  = "docker.io/teammeraki/backend:latest"
    cpu    = "1"
    memory = "1.5"

    ports {
      port     = 8000
      protocol = "TCP"
    }

    environment_variables = {
      DATABASE_URL = "postgres://${var.db_admin_login}:${var.db_admin_password}@${var.db_host}:5432/${var.db_name}"
    }
  }

  container {
    name   = "frontend"
    image  = "docker.io/teammeraki/frontend:latest"
    cpu    = "1"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}
# Provider Configuration
provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-rg"
  location = var.location
}

# Virtual Networks
resource "azurerm_virtual_network" "public_vnet" {
  name                = "${var.prefix}-public-vnet"
  address_space       = [var.public_vnet_cidr]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_virtual_network" "private_vnet" {
  name                = "${var.prefix}-private-vnet"
  address_space       = [var.private_vnet_cidr]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Subnets
resource "azurerm_subnet" "public_subnet" {
  name                 = "${var.prefix}-public-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.public_vnet.name
  address_prefixes     = [var.public_subnet_cidr]
}

resource "azurerm_subnet" "private_subnet" {
  name                 = "${var.prefix}-private-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.private_vnet.name
  address_prefixes     = [var.private_subnet_cidr]
}

# App Service Plan
resource "azurerm_service_plan" "app_service_plan" {
  name                = "${var.prefix}-app-plan"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = "B1"
}

# Back-end App Service
resource "azurerm_app_service" "backend_app" {
  name                = "${var.prefix}-backend"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_service_plan.app_service_plan.id

  site_config {
    always_on = true
  }

  app_settings = {
    "DATABASE_URL" = "YourDatabaseConnectionString"
  }
}

# Storage Account for Front-end
resource "azurerm_storage_account" "frontend_storage" {
  name                     = "frontendstorage${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  static_website {
    index_document = "index.html"
  }
}

# Application Insights for SRE
resource "azurerm_application_insights" "app_insights" {
  name                = "${var.prefix}-insights"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = "web"
}

# PostgreSQL Database
resource "azurerm_postgresql_server" "db_server" {
  name                = "${var.prefix}-db"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "B_Gen5_1"
  storage_mb          = 5120
  administrator_login = var.db_admin_user
  administrator_login_password = var.db_admin_password
  version = "11"
}

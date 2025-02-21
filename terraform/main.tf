provider "azurerm" {
  features {}
}

locals {
  name_prefix = "${var.prefix}"
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${local.name_prefix}-rg"
  location = var.location
}

# Public Virtual Network
resource "azurerm_virtual_network" "public_vnet" {
  name                = "${local.name_prefix}-public-vnet"
  address_space       = [var.public_vnet_cidr]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = merge(
    var.default_tags,
    {
      Name = "${local.name_prefix}-public-vnet"
    }
  )
}

# Private Virtual Network
resource "azurerm_virtual_network" "private_vnet" {
  name                = "${local.name_prefix}-private-vnet"
  address_space       = [var.private_vnet_cidr]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = merge(
    var.default_tags,
    {
      Name = "${local.name_prefix}-private-vnet"
    }
  )
}

# Public Subnet
resource "azurerm_subnet" "public_subnet" {
  name                 = "${local.name_prefix}-public-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.public_vnet.name
  address_prefixes     = [var.public_subnet_cidr]

  tags = merge(
    var.default_tags,
    {
      Name = "${local.name_prefix}-public-subnet"
    }
  )
}

# Private Subnet
resource "azurerm_subnet" "private_subnet" {
  name                 = "${local.name_prefix}-private-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.private_vnet.name
  address_prefixes     = [var.private_subnet_cidr]

  tags = merge(
    var.default_tags,
    {
      Name = "${local.name_prefix}-private-subnet"
    }
  )
}

# Public IP Address for accessing the frontend
resource "azurerm_public_ip" "public_ip" {
  name                = "${local.name_prefix}-public-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"

  tags = merge(
    var.default_tags,
    {
      Name = "${local.name_prefix}-public-ip"
    }
  )
}

# Network Interface for the frontend service
resource "azurerm_network_interface" "frontend_nic" {
  name                = "${local.name_prefix}-frontend-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "${local.name_prefix}-ipconfig"
    subnet_id                     = azurerm_subnet.public_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

  tags = merge(
    var.default_tags,
    {
      Name = "${local.name_prefix}-frontend-nic"
    }
  )
}

# (Optional) Create a PostgreSQL Database in the private subnet
resource "azurerm_postgresql_server" "db" {
  name                = "${local.name_prefix}-db-server"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  version             = "11"
  administrator_login = var.db_admin_user
  administrator_login_password = var.db_admin_password
  sku {
    name     = "B_Gen5_1"
    tier     = "Basic"
    capacity = 1
  }
  storage_mb = 5120
  ssl_enforcement = "Enabled"
  
  tags = merge(
    var.default_tags,
    {
      Name = "${local.name_prefix}-db-server"
    }
  )
}

# (Optional) Create a Database
resource "azurerm_postgresql_database" "database" {
  name                = "${local.name_prefix}-database"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_postgresql_server.db.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}
provider "azurerm" {
  features {}
}

locals {
  name_prefix = var.prefix
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
}

# Private Virtual Network
resource "azurerm_virtual_network" "private_vnet" {
  name                = "${local.name_prefix}-private-vnet"
  address_space       = [var.private_vnet_cidr]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Public Subnet (Frontend)
resource "azurerm_subnet" "public_subnet" {
  name                 = "${local.name_prefix}-public-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.public_vnet.name
  address_prefixes     = [var.public_subnet_cidr]
}

# Private Subnet (Backend & DB)
resource "azurerm_subnet" "private_subnet" {
  name                 = "${local.name_prefix}-private-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.private_vnet.name
  address_prefixes     = [var.private_subnet_cidr]
}

provider "azurerm" {
  subscription_id = "751c3db3-3eb2-4eee-a457-96496fe2905c"
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-rg"
  location = var.location
}

# Public Virtual Network
resource "azurerm_virtual_network" "public_vnet" {
  name                = "${var.prefix}-public-vnet"
  address_space       = [var.public_vnet_cidr]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Private Virtual Network
resource "azurerm_virtual_network" "private_vnet" {
  name                = "${var.prefix}-private-vnet"
  address_space       = [var.private_vnet_cidr]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Public Subnet
resource "azurerm_subnet" "public_subnet" {
  name                 = "${var.prefix}-public-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.public_vnet.name
  address_prefixes     = [var.public_subnet_cidr]
}

# Private Subnet
resource "azurerm_subnet" "private_subnet" {
  name                 = "${var.prefix}-private-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.private_vnet.name
  address_prefixes     = [var.private_subnet_cidr]
}

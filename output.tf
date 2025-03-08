output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "public_vnet_name" {
  value = azurerm_virtual_network.public_vnet.name
}

output "private_vnet_name" {
  value = azurerm_virtual_network.private_vnet.name
}

output "public_subnet_name" {
  value = azurerm_subnet.public_subnet.name
}

output "private_subnet_name" {
  value = azurerm_subnet.private_subnet.name
}

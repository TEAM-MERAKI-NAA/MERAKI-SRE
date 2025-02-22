output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "public_vnet_name" {
  value = azurerm_virtual_network.public_vnet.name
}

output "private_vnet_name" {
  value = azurerm_virtual_network.private_vnet.name
}

output "public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}

output "db_server_name" {
  value = azurerm_postgresql_server.db.name
}

output "database_name" {
  value = azurerm_postgresql_database.database.name
}
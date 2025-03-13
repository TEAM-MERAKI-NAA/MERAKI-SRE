
# Adding Tags
output "tags" {
  value = local.project_tags
}

# Resource Group
output "resource_group_name" {
  description = "The name of the Azure Resource Group"
  value       = azurerm_resource_group.main.name
}

# Virtual Networks
output "public_vnet_name" {
  description = "The name of the public Virtual Network"
  value       = azurerm_virtual_network.public_vnet.name
}

output "private_vnet_name" {
  description = "The name of the private Virtual Network"
  value       = azurerm_virtual_network.private_vnet.name
}

# Subnets
output "public_subnet_name" {
  description = "The name of the public subnet"
  value       = azurerm_subnet.public_subnet.name
}

output "private_subnet_name" {
  description = "The name of the private subnet"
  value       = azurerm_subnet.private_subnet.name
}

# Frontend (Static Website)
output "frontend_url" {
  description = "The URL for the front-end website hosted in Azure Storage"
  value       = azurerm_storage_account.frontend_storage.primary_web_host
}

output "frontend_storage_account_name" {
  description = "The name of the storage account hosting the front-end"
  value       = azurerm_storage_account.frontend_storage.name
}

# Backend (App Service)
output "backend_url" {
  description = "The URL for the back-end application running on Azure App Service"
  value       = "https://${azurerm_app_service.backend_app.default_site_hostname}"
}

output "backend_app_name" {
  description = "The name of the back-end App Service"
  value       = azurerm_app_service.backend_app.name
}

# Database (PostgreSQL)
output "database_url" {
  description = "The FQDN of the PostgreSQL database"
  value       = azurerm_postgresql_server.db_server.fqdn
}

output "database_admin_user" {
  description = "The database administrator username"
  value       = var.db_admin_user
  sensitive   = true
}

# App Service Plan
output "app_service_plan_id" {
  description = "The ID of the App Service Plan"
  value       = azurerm_service_plan.app_service_plan.id
}

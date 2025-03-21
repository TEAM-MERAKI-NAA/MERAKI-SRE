# SSH Key Outputs
output "ssh_private_key" {
  value     = tls_private_key.ssh.private_key_pem
  sensitive = true
}

output "ssh_public_key" {
  value = tls_private_key.ssh.public_key_openssh
}

# ACR Outputs
output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_username" {
  value = azurerm_container_registry.acr.admin_username
}

output "acr_password" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}

# VM Outputs
output "vm_public_ip" {
  value = azurerm_public_ip.vm_public_ip.ip_address
}

output "vm_username" {
  value = var.admin_username
}

# Application URLs
output "application_urls" {
  value = {
    react_app  = "http://${azurerm_public_ip.vm_public_ip.ip_address}:3000"
    django_app = "http://${azurerm_public_ip.vm_public_ip.ip_address}:8000"
  }
}

# Resource Information
output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "virtual_machine_name" {
  value = azurerm_linux_virtual_machine.vm.name
}

# Connection String
output "ssh_connection_string" {
  value = "ssh ${var.admin_username}@${azurerm_public_ip.vm_public_ip.ip_address}"
} 
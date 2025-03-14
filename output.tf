output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "virtual_machine_name" {
  value = azurerm_linux_virtual_machine.vm.name
}

output "public_ip_address" {
  value = azurerm_public_ip.vm_public_ip.ip_address
  description = "The public IP address of the virtual machine"
}

output "ssh_connection_string" {
  value = "ssh ${var.admin_username}@${azurerm_public_ip.vm_public_ip.ip_address}"
  description = "Command to use to connect to the VM via SSH"
}

output "application_urls" {
  value = {
    react_app = "http://${azurerm_public_ip.vm_public_ip.ip_address}:3000"
    django_app = "http://${azurerm_public_ip.vm_public_ip.ip_address}:8000"
  }
  description = "URLs to access the applications"
}

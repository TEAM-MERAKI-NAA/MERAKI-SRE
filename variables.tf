# terraform/variables.tf
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "db_server_name" {
  description = "Name of the PostgreSQL server"
  type        = string
}

variable "db_admin_login" {
  description = "Admin login for PostgreSQL"
  type        = string
}

variable "db_admin_password" {
  description = "Admin password for PostgreSQL"
  type        = string
}

variable "db_name" {
  description = "Name of the PostgreSQL database"
  type        = string
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
}
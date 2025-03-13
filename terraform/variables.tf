variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "public_vnet_cidr" {
  description = "CIDR block for the Public Virtual Network"
  type        = string
}

variable "private_vnet_cidr" {
  description = "CIDR block for the Private Virtual Network"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
}

variable "db_admin_user" {
  description = "Database administrator username"
  type        = string
}

variable "db_admin_password" {
  description = "Database administrator password"
  type        = string
}

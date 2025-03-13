# giving the prefix for resource name 
variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

# Declaring the location 
variable "location" {
  description = "Azure location"
  type        = string
}

#CIDR for Public Virtual Network
variable "public_vnet_cidr" {
  description = "CIDR block for the Public Virtual Network"
  type        = string
}

#CIDR for Private Virtual Network
variable "private_vnet_cidr" {
  description = "CIDR block for the Private Virtual Network"
  type        = string
}

#CIDR for Public Subnet
variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

#CIDR for Private Subnet
variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
}

#Database admin user 
variable "db_admin_user" {
  description = "Database administrator username"
  type        = string
}

#Database admin password 
variable "db_admin_password" {
  description = "Database administrator password"
  type        = string
}

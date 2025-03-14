# Azure Web Hosting Terraform Configuration

This Terraform configuration sets up an Azure infrastructure for hosting a web application with React frontend, Django backend, and PostgreSQL database.

## Infrastructure Components

- **Single Ubuntu VM**: Hosts all application components
- **Public IP**: Allows access from the internet
- **Single VNet with Public Subnet**: Network infrastructure
- **Network Security Group**: Controls traffic with specific inbound rules
- **Custom Data Script**: Automatically installs all required software

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed (v1.0.0+)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed and configured
- SSH key pair for VM access

## Configuration Files

The project consists of three main files:

- **main.tf**: Contains the primary infrastructure configuration
- **variables.tf**: Defines customizable variables for the deployment
- **outputs.tf**: Specifies useful output values after deployment 

## Network Security Rules

The configuration allows the following traffic:

- **Inbound**: 
  - SSH (Port 22): For server management
  - Web Ports (3000, 3001): For React applications
  - API Port (8000): For Django backend
- **Outbound**: All traffic allowed

## Software Installation

The VM comes pre-installed with:
- **Node.js and React**: Frontend development
- **PostgreSQL**: Database services
- **Python and Django**: Backend development

## Deployment Instructions

1. **Clone this repository**:
   ```
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Initialize Terraform**:
   ```
   terraform init
   ```

3. **Review the deployment plan**:
   ```
   terraform plan
   ```

4. **Deploy the infrastructure**:
   ```
   terraform apply
   ```

5. **Confirm the deployment** by typing `yes` when prompted.

After successful deployment, Terraform will display important information such as the VM's public IP address and SSH connection string.

## Accessing Your Server

Connect to your VM using SSH:
```
ssh adminuser@<public-ip>
```
(Replace `adminuser` with your configured admin username if changed)

## Deploying Your Website

1. **Connect to your VM** via SSH
2. **Clone your website code**
3. **Configure your applications**:
   - React application typically runs on port 3000
   - Django application typically runs on port 8000
   - PostgreSQL runs on default port 5432

## Production Considerations

For a production environment, consider:
- Implementing SSL/TLS with Let's Encrypt
- Configuring a domain name
- Setting up applications as services
- Implementing a reverse proxy (Nginx/Apache)
- Regular backups for your database

## Customization

Edit the `variables.tf` file to customize:
- Resource prefix
- Azure region
- VM administrator username
- SSH public key path

## Cleanup

To remove all resources when no longer needed:
```
terraform destroy
```

## Support

For issues or questions, please file an issue in the repository or contact the project maintainer.

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

# MERAKI SRE Repository

This repository contains the Site Reliability Engineering (SRE) configurations and deployment scripts for the MERAKI project.

## Frontend Docker Setup

### Prerequisites
- Docker installed on your system
- Node.js 20.x (for local development)
- Access to the MERAKI-FE repository

### Dockerfile Configuration
The frontend Dockerfile is located in `MERAKI-FE/Dockerfile` with the following configuration:

```dockerfile
# Use Node.js image
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy project files
COPY . .

# Build the app
RUN npm run build

# Set environment variables
ENV HOST=0.0.0.0
ENV PORT=3000
ENV WDS_SOCKET_PORT=0

# Expose port
EXPOSE 3000

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:3000/ || exit 1

# Start the development server with host flag
CMD ["npm", "run", "start", "--", "--host", "0.0.0.0", "--port", "3000"]
```

### Building and Running the Container

1. Navigate to the frontend directory:
```bash
cd MERAKI-FE
```

2. Build the Docker image:
```bash
sudo docker build -t immigrationhub .
```

3. Run the container:
```bash
sudo docker run -d -p 3000:3000 immigrationhub
```

4. Verify the container is running:
```bash
sudo docker ps
```

5. Check container logs:
```bash
sudo docker logs $(sudo docker ps -q)
```

### Troubleshooting

#### Permission Issues
If you encounter permission issues:

1. Add your user to the docker group:
```bash
sudo usermod -aG docker $USER
```

2. Apply the group changes:
```bash
newgrp docker
```

### Accessing the Application
- Local access: http://localhost:3000
- Remote access: http://<your-vm-ip>:3000

### Health Checks
The container includes a healthcheck that runs every 30 seconds to verify the application is responding correctly.

### Environment Variables
- `HOST`: Set to 0.0.0.0 to allow external access
- `PORT`: Set to 3000 for the development server
- `WDS_SOCKET_PORT`: Set to 0 for WebSocket connections

## Contributing
1. Create a new branch for your changes
2. Make your changes
3. Test the Docker build and run process
4. Submit a pull request

## License
This project is licensed under the MIT License - see the LICENSE file for details.

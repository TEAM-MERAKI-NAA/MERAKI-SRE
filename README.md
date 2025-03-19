# MERAKI SRE Deployment Guide

## Step 1: Infrastructure Setup

### Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) installed (v1.0.0+)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed and configured
- SSH key pair for VM access

### Infrastructure Components
- **Single Ubuntu VM**: Hosts all application components
- **Public IP**: Allows access from the internet
- **Single VNet with Public Subnet**: Network infrastructure
- **Network Security Group**: Controls traffic with specific inbound rules
- **Custom Data Script**: Automatically installs all required software

### Network Security Rules
- **Inbound**: 
  - SSH (Port 22): For server management
  - Web Ports (3000, 3001): For React applications
  - API Port (8000): For Django backend
- **Outbound**: All traffic allowed

### Deployment Steps
1. Clone the repository:
```bash
git clone <repository-url>
cd <repository-directory>
```

2. Initialize Terraform:
```bash
terraform init
```

3. Review the deployment plan:
```bash
terraform plan
```

4. Deploy the infrastructure:
```bash
terraform apply
```

5. Confirm the deployment by typing `yes` when prompted.

## Step 2: Server Access and Verification

1. Connect to your VM using SSH:
```bash
ssh adminuser@<public-ip>
```

2. Verify pre-installed software:
```bash
# Check Docker
docker --version

# Check Node.js
node --version

# Check Python
python3 --version

# Check PostgreSQL
psql --version
```

## Step 3: Frontend Deployment

### Frontend Dockerfile (MERAKI-FE/Dockerfile)
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

### Frontend Deployment Steps
1. Navigate to frontend directory:
```bash
cd MERAKI-FE
```

2. Build the Docker image:
```bash
docker build -t immigrationhub .
```

3. Run the container:
```bash
docker run -d -p 3000:3000 immigrationhub
```

## Step 4: Backend Deployment

### Backend Dockerfile (MERAKI-BE/Dockerfile)
```dockerfile
# Use Python 3.11 slim image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV DJANGO_SETTINGS_MODULE=meraki.settings
ENV ALLOWED_HOSTS=*
ENV DEBUG=True

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    postgresql-client \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project
COPY . .

# Expose port
EXPOSE 8000

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health/ || exit 1

# Run migrations and start server with explicit host and port
CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000 --noreload"]
```

### Backend Deployment Steps
1. Navigate to backend directory:
```bash
cd MERAKI-BE
```

2. Build the Docker image:
```bash
docker build -t meraki-backend .
```

3. Run the container:
```bash
docker run -d -p 8000:8000 meraki-backend
```

## Step 5: Container Management

### Common Commands
- Check container status:
```bash
docker ps
```

- View container logs:
```bash
docker logs $(docker ps -q)
```

- Stop containers:
```bash
docker stop $(docker ps -q)
```

- Remove containers:
```bash
docker rm $(docker ps -aq)
```

## Step 6: Application Access

### URLs
- Frontend: http://<your-vm-ip>:3000
- Backend API: http://<your-vm-ip>:8000

### Environment Variables

#### Frontend
- `HOST`: Set to 0.0.0.0 to allow external access
- `PORT`: Set to 3000 for the development server
- `WDS_SOCKET_PORT`: Set to 0 for WebSocket connections

#### Backend
- `PYTHONDONTWRITEBYTECODE`: Prevents Python from writing .pyc files
- `PYTHONUNBUFFERED`: Ensures Python output is sent straight to the terminal
- `DJANGO_SETTINGS_MODULE`: Specifies the Django settings module
- `ALLOWED_HOSTS`: Set to * to allow all hosts (configure appropriately for production)
- `DEBUG`: Set to True for development (set to False in production)

## Step 7: Production Considerations

### Security
- Implement SSL/TLS with Let's Encrypt
- Configure a domain name
- Set DEBUG=False in Django settings
- Configure proper ALLOWED_HOSTS in Django

### Infrastructure
- Set up applications as services
- Implement a reverse proxy (Nginx/Apache)
- Regular backups for your database

## Step 8: Cleanup

To remove all resources when no longer needed:
```bash
terraform destroy
```

## Support

For issues or questions, please file an issue in the repository or contact the project maintainer.
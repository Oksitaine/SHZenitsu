# OVH Self-Hosting Infrastructure

A streamlined infrastructure-as-code project for deploying self-hosting environments on OVH cloud using Terraform and Ansible.

## Overview

This project provides a solid foundation for self-hosting applications on OVH's cloud platform. It automatically provisions a virtual machine and sets up Nginx Proxy Manager to easily manage HTTP redirections, SSL certificates, and proxying for your web applications.

**Key Features:**
- Infrastructure as code with Terraform
- Configuration management with Ansible
- Automatic VM provisioning on OVH Cloud
- SSH key management and secure access setup
- Nginx Proxy Manager pre-installed for web traffic management
- Docker and Docker Compose for containerized deployments

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) (v1.0.0+)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (v2.9.0+)
- [OVH Account](https://www.ovhcloud.com/) with Public Cloud access
- OVH API credentials (see configuration section)

## Configuration

### 1. OVH API Credentials

First, you need to create OVH API credentials:

1. Go to https://www.ovh.com/auth/api/createToken?GET=/*&POST=/*&PUT=/*&DELETE=/*
2. Set appropriate rights (at minimum read/write for public cloud)
3. Save the generated credentials

### 2. Setup Variables

Copy the template variables file and adjust it to your needs:

```bash
cp variable.template.tfvars variable.tfvars
```

Edit `variable.tfvars` with your specific information:

```hcl
# OVH API credentials
ovh_keys = {
  endpoint = "ovh-eu"
  application_key = "your_application_key"
  application_secret = "your_application_secret"
  consumer_key = "your_consumer_key"
}

# Your OVH Public Cloud project ID
service_public_cloud = "your_public_cloud_project_id"

# OVH OAuth token
ovh_token_oauth = "your_ovh_token"

# Docker Hub credentials (for pulling images)
docker_login = {
  username = "your_docker_username"
  password = "your_docker_password"
}

# VM configuration
virtual_machine = {
  name = "your_vm_name"
  region = "GRA11"  # Change to your preferred region
  billing_period = "hourly"
  flavor_id = "your_vm_flavor_id"  # See module comments for how to retrieve this
  image_id = "your_vm_image_id"    # See module comments for how to retrieve this
  network_public = true
  ssh_key = "your_ssh_key_name"
  ssh_key_public = "your_public_ssh_key_string"
  user_data = "ssh.bash"  # Do not change unless you know what you're doing
}
```

> [!IMPORTANT]
> For `flavor_id` and `image_id`, check the comments in `terraform/module/ovh_vm/variables.tf` for instructions on how to retrieve these IDs from the OVH API.

## Deployment

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Apply the Configuration

```bash
terraform apply -var-file=variable.tfvars
```

The deployment process:
1. Creates a VM on OVH cloud
2. Configures SSH access
3. Uses Ansible to install Docker and Nginx Proxy Manager
4. Sets up Docker Compose for application deployment

## Usage

### Accessing Nginx Proxy Manager

After deployment, Nginx Proxy Manager will be available at:

- Admin panel: http://YOUR_SERVER_IP:81
- Default credentials:
  - Username: demonslayer
  - Password: password

**Important:** Change the default credentials immediately after first login!

## Project Structure

```
├── ansible/                # Ansible configuration
│   ├── docker.yml          # Docker installation tasks
│   └── main.yml            # Main Ansible playbook
├── app/                    # Application configuration
│   └── docker-compose.yml  # Docker Compose for deployed apps
├── terraform/
│   └── module/
│       └── ovh_vm/         # OVH VM Terraform module
├── main.tf                 # Main Terraform configuration
├── variable.tf             # Variable definitions
├── variable.template.tfvars # Template for variables
└── ssh.bash               # SSH configuration script
```

## Potential Improvements

- Object Storage (S3) integration
- Database management
- Automated backups
- Multi-VM setup for high availability
- CI/CD pipeline integration
- Enhanced security configurations
- Monitoring and logging solutions

## Troubleshooting

If you encounter SSH connection issues:
- Verify your SSH key is correctly configured in the variables file
- Check that port 22 is accessible (OVH firewall settings)
- Ensure the VM initialization is complete (can take a few minutes)

For OVH API issues:
- Verify API credentials have sufficient permissions
- Ensure your OVH account has Public Cloud enabled

## License

This project is available as open source under the terms of the [MIT License](LICENSE).

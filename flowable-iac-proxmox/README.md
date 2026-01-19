# Flowable Infrastructure as Code - Proxmox

This directory contains Terraform/OpenTofu modules and deployment configurations for deploying Flowable on Proxmox Virtual Environment.

## Architecture

The infrastructure uses:
- **Proxmox VE**: Hypervisor for running VMs
- **K3s**: Lightweight Kubernetes distribution running on VMs
- **bpg/proxmox** provider: Terraform provider for Proxmox
- **OpenTofu**: Open-source Terraform alternative

## Modules

### Infrastructure Modules (`flowable-iac-modules-proxmox/`)

- **resource-pool**: Organizes VMs into logical pools
- **k8s/k3s-cluster**: Creates K3s Kubernetes cluster VMs
  - Master nodes (control plane)
  - Worker nodes (application workloads)
- **postgresql-vm**: PostgreSQL database server VM
- **elk**: Elasticsearch and Kibana for logging/search
- **k8s/ingress-nginx**: NGINX Ingress Controller
- **flowable-app**: Flowable application deployment

### Deployment Configurations (`flowable-iac-deployments-proxmox/`)

Coming soon: Environment-specific configurations for dev, prod, etc.

## Prerequisites

1. **Proxmox VE** cluster up and running
2. **Ubuntu cloud-init template** created in Proxmox (template ID: 9000)
3. **OpenTofu** or Terraform installed
4. **Terragrunt** (optional, for managing multiple environments)
5. **SSH keys** configured for VM access

### Creating Ubuntu Cloud-Init Template

```bash
# Download Ubuntu cloud image
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img

# Create VM template
qm create 9000 --name ubuntu-cloud-init --memory 2048 --net0 virtio,bridge=vmbr0
qm importdisk 9000 jammy-server-cloudimg-amd64.img local-lvm
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0
qm set 9000 --ide2 local-lvm:cloudinit
qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --serial0 socket --vga serial0
qm template 9000
```

## Key Differences from Azure

| Component | Azure | Proxmox |
|-----------|-------|---------|
| Provider | azurerm | bpg/proxmox |
| Kubernetes | AKS (managed) | K3s (self-managed on VMs) |
| Resource Group | Azure Resource Group | Proxmox Resource Pool |
| PostgreSQL | Managed Azure PostgreSQL | PostgreSQL on VM |
| Networking | Azure VNET | Proxmox bridge + VLANs |
| Storage | Azure Managed Disks | Proxmox storage (local-lvm, NFS, etc.) |

## Usage

### Initialize Provider

```hcl
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.50.0"
    }
  }
}

provider "proxmox" {
  endpoint = "https://proxmox.example.com:8006"
  username = "root@pam"
  password = var.proxmox_password
  insecure = false
}
```

### Deploy Infrastructure

```bash
# Initialize
tofu init

# Plan
tofu plan

# Apply
tofu apply
```

### Post-Deployment Steps

After VMs are created, you'll need to:

1. **Install K3s on master node**:
   ```bash
   ssh ubuntu@master-ip
   curl -sfL https://get.k3s.io | sh -
   sudo cat /var/lib/rancher/k3s/server/node-token
   ```

2. **Join worker nodes**:
   ```bash
   ssh ubuntu@worker-ip
   curl -sfL https://get.k3s.io | K3S_URL=https://master-ip:6443 K3S_TOKEN=<token> sh -
   ```

3. **Get kubeconfig**:
   ```bash
   ssh ubuntu@master-ip sudo cat /etc/rancher/k3s/k3s.yaml > ~/.kube/config
   # Update server address in config file
   ```

4. **Install PostgreSQL on database VM**:
   ```bash
   ssh ubuntu@db-ip
   sudo apt update && sudo apt install -y postgresql
   ```

## Module Documentation

Each module contains its own README with detailed usage instructions, inputs, and outputs.

## Notes

- K3s is lightweight and perfect for edge/on-prem deployments
- Resource requirements are lower than managed Kubernetes
- Manual cluster setup required (no managed service like AKS)
- Consider high-availability setup for production (3+ master nodes)

## Support

For issues or questions, please refer to:
- [bpg/proxmox provider docs](https://registry.terraform.io/providers/bpg/proxmox/latest/docs)
- [K3s documentation](https://docs.k3s.io/)
- [OpenTofu documentation](https://opentofu.org/docs/)

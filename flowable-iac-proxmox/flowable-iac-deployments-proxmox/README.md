# Flowable Infrastructure as Code - Deployments - Proxmox

This folder contains example Terragrunt configurations for deploying Flowable on a K3s cluster on Proxmox Virtual Environment.

## Structure

The deployment structure mirrors the Azure setup but adapted for Proxmox:

```
account (prod/non-prod)
└ site (physical location: site1, site2, etc.)
    └ environment (prod, dev, qa)
        └ resource (foundation/app components)
```

## Prerequisites

Before deploying, ensure you have:

1. Proxmox VE cluster accessible
2. Ubuntu cloud-init template created (template ID: 9000)
3. OpenTofu or Terraform installed
4. SSH keys configured
5. Proxmox credentials configured

## Configuration

Set environment variables for Proxmox authentication:

```bash
export PROXMOX_VE_ENDPOINT="https://proxmox.example.com:8006"
export PROXMOX_VE_USERNAME="root@pam"
export PROXMOX_VE_PASSWORD="your-password"
```

## Deployment Steps

1. **Initialize Terragrunt**:
   ```bash
   cd non-prod/site1/dev/
   terragrunt run-all init
   ```

2. **Review planned changes**:
   ```bash
   terragrunt run-all plan
   ```

3. **Apply configuration**:
   ```bash
   terragrunt run-all apply
   ```

## Post-Deployment

After infrastructure is created:

1. Configure K3s cluster (master + workers)
2. Setup PostgreSQL on database VM
3. Deploy applications using Helm

See the main Proxmox README for detailed post-deployment steps.

## Components

The deployment includes:
- **Resource Pool**: Organizes all VMs
- **K3s Cluster**: Master and worker VMs
- **PostgreSQL VM**: Database server
- **ELK Stack**: Elasticsearch and Kibana (on K3s)
- **Flowable App**: Application deployment (on K3s)

## Environment Differences

- **Dev**: Minimal resources (1 master, 2 workers, smaller VMs)
- **Prod**: HA setup (3 masters, 3+ workers, larger VMs)

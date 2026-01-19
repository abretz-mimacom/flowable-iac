# Proxmox - K3s Cluster Module

This is a Terraform module for creating a K3s Kubernetes cluster on Proxmox Virtual Environment.

## Overview

This module creates a K3s cluster by provisioning VMs on Proxmox:
- Master nodes (control plane)
- Worker nodes (application workloads)

K3s is a lightweight Kubernetes distribution that's perfect for edge computing, IoT, and resource-constrained environments.

## Prerequisites

- Ubuntu cloud-init template must be created in Proxmox (default template ID: 9000)
- SSH keys configured for VM access
- Sufficient resources on Proxmox node

## Usage

```hcl
module "k3s_cluster" {
  source = "../modules/k8s/k3s-cluster"

  cluster_name        = "flowable-iac"
  env_suffix          = "prod"
  resource_pool_name  = module.resource_pool.pool_id
  
  master_count        = 1
  master_vm_cpu       = 2
  master_vm_memory    = 4096
  master_vm_disk_size = 32
  
  worker_count        = 2
  worker_vm_cpu       = 4
  worker_vm_memory    = 8192
  worker_vm_disk_size = 64
  
  ssh_keys = [
    "ssh-rsa AAAAB3..."
  ]
}
```

## Post-Deployment

After VMs are created, you need to:
1. SSH into the master node
2. Install K3s: `curl -sfL https://get.k3s.io | sh -`
3. Get the node token from `/var/lib/rancher/k3s/server/node-token`
4. Join worker nodes using the token

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| cluster_name | Name of the K3s cluster | string | - | yes |
| env_suffix | Environment suffix | string | - | yes |
| resource_pool_name | Name of the Proxmox resource pool | string | - | yes |
| node_name | Proxmox node name | string | "pve" | no |
| kubernetes_version | Kubernetes version for K3s | string | "v1.27.3+k3s1" | no |
| master_count | Number of master nodes | number | 1 | no |
| master_vm_cpu | CPUs for master nodes | number | 2 | no |
| master_vm_memory | Memory in MB for master nodes | number | 4096 | no |
| master_vm_disk_size | Disk size in GB for master nodes | number | 32 | no |
| worker_count | Number of worker nodes | number | 2 | no |
| worker_vm_cpu | CPUs for worker nodes | number | 4 | no |
| worker_vm_memory | Memory in MB for worker nodes | number | 8192 | no |
| worker_vm_disk_size | Disk size in GB for worker nodes | number | 64 | no |
| vm_template_id | Template ID for VM cloning | number | 9000 | no |
| storage_name | Storage name for VM disks | string | "local-lvm" | no |
| network_bridge | Network bridge for VMs | string | "vmbr0" | no |
| ssh_keys | SSH public keys for VM access | list(string) | [] | no |
| vlan_tag | VLAN tag for network isolation | number | null | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_name | The name of the K3s cluster |
| master_vm_ids | IDs of the master VMs |
| worker_vm_ids | IDs of the worker VMs |
| master_ips | IP addresses of master nodes |
| worker_ips | IP addresses of worker nodes |
| resource_pool_name | The resource pool name |

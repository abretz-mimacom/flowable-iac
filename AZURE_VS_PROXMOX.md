# Azure vs Proxmox Module Comparison

This document provides a comparison between the Azure and Proxmox implementations of the Flowable infrastructure.

## Provider Comparison

| Aspect | Azure | Proxmox |
|--------|-------|---------|
| **Provider** | `hashicorp/azurerm` | `bpg/proxmox` |
| **IaC Tool** | Terraform | OpenTofu (or Terraform) |
| **Cloud Type** | Public Cloud | On-Premises / Private Cloud |
| **Management** | Fully Managed Services | Self-Managed Infrastructure |

## Module Mapping

### Core Infrastructure

| Azure Module | Proxmox Module | Notes |
|--------------|----------------|-------|
| `resource-group` | `resource-pool` | Logical grouping of resources |
| `k8s/aks-cluster` | `k8s/k3s-cluster` | Managed AKS vs Self-managed K3s on VMs |
| `postgresql-managed-flexible-server` | `postgresql-vm` | Managed service vs PostgreSQL on VM |
| `elk` | `elk` | Same (deployed on K8s) |
| `flowable-app` | `flowable-app` | Same (Helm deployment) |
| `k8s/ingress-nginx` | `k8s/ingress-nginx` | Same (Helm deployment) |

### Key Differences

#### 1. Kubernetes

**Azure (AKS)**:
- Managed control plane
- Automatic updates
- Built-in monitoring
- Azure AD integration
- Scales automatically

**Proxmox (K3s)**:
- Self-managed control plane
- Manual updates required
- Manual monitoring setup
- SSH-based access
- Manual scaling

#### 2. Networking

**Azure**:
```hcl
# Virtual Network and Subnets
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-name"
  address_space       = ["10.1.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group_name
  address_prefixes     = ["10.1.0.0/22"]
}
```

**Proxmox**:
```hcl
# Network bridge with optional VLAN
network_device {
  bridge  = "vmbr0"
  vlan_id = 100  # Optional VLAN tag
}
```

#### 3. Storage

**Azure**:
- Managed Disks (Premium SSD, Standard SSD, etc.)
- Azure Files for shared storage
- Storage classes: `default`, `managed-premium`, `azurefile-csi-premium`

**Proxmox**:
- Local storage (local-lvm, local-zfs)
- Network storage (NFS, Ceph, iSCSI)
- Storage classes depend on CSI driver configuration

#### 4. Authentication

**Azure**:
- Azure AD for user authentication
- Service Principals for automation
- Managed Identity for services
- Key Vault for secrets

**Proxmox**:
- PAM/PVE authentication
- API tokens for automation
- SSH keys for VM access
- Manual secret management (or Vault)

## Resource Configuration Examples

### Creating a Resource Pool/Group

**Azure**:
```hcl
resource "azurerm_resource_group" "rg" {
  name     = "rg-flowable-prod"
  location = "northeurope"
}
```

**Proxmox**:
```hcl
resource "proxmox_virtual_environment_pool" "pool" {
  pool_id = "flowable-prod"
  comment = "Flowable production environment"
}
```

### Creating Kubernetes Cluster

**Azure (AKS)**:
```hcl
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-flowable-prod"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "flowable"
  kubernetes_version  = "1.27.3"
  
  default_node_pool {
    name       = "system"
    node_count = 2
    vm_size    = "Standard_D2s_v3"
  }
}
```

**Proxmox (K3s)**:
```hcl
resource "proxmox_virtual_environment_vm" "k3s_master" {
  name        = "k3s-master-1"
  node_name   = "pve"
  
  clone {
    vm_id = 9000  # Ubuntu template
  }
  
  cpu {
    cores = 2
  }
  
  memory {
    dedicated = 4096
  }
  
  disk {
    datastore_id = "local-lvm"
    size         = 32
  }
}
# Post-deployment: Install K3s manually
```

## Cost Considerations

### Azure
- Pay for what you use (compute, storage, bandwidth)
- Managed services include management overhead costs
- Predictable monthly billing
- Can be expensive for long-running workloads

### Proxmox
- Upfront hardware costs
- No ongoing cloud costs
- Fixed costs (power, cooling, maintenance)
- More cost-effective for predictable workloads
- Requires in-house expertise

## High Availability

### Azure
- Built-in HA for managed services
- Availability Zones
- Automatic failover
- 99.95% SLA for AKS

### Proxmox
- Manual HA configuration
- Requires multiple nodes
- Shared storage needed
- Manual failover scripts
- SLA depends on your setup

## Monitoring & Logging

### Azure
- Azure Monitor
- Log Analytics
- Application Insights
- Built-in dashboards

### Proxmox
- Prometheus + Grafana (manual setup)
- ELK stack for logging
- Custom dashboards
- More configuration required

## When to Use Each

### Use Azure When:
- Need managed services
- Want automatic scaling
- Require global distribution
- Prefer OpEx over CapEx
- Need enterprise SLAs
- Have variable workloads

### Use Proxmox When:
- Have existing on-prem infrastructure
- Need full control
- Want to minimize recurring costs
- Have stable/predictable workloads
- Have in-house virtualization expertise
- Require data sovereignty

## Migration Path

To migrate from Azure to Proxmox:

1. **Infrastructure**: Deploy Proxmox modules
2. **Cluster**: Setup K3s cluster
3. **Storage**: Configure persistent storage
4. **Database**: Migrate PostgreSQL data
5. **Applications**: Deploy using same Helm charts
6. **Testing**: Validate functionality
7. **Cutover**: Update DNS/routing

To migrate from Proxmox to Azure:

1. **Planning**: Size Azure resources
2. **Infrastructure**: Deploy Azure modules
3. **Cluster**: Provision AKS cluster
4. **Storage**: Setup Azure storage
5. **Database**: Migrate to Azure PostgreSQL
6. **Applications**: Deploy using same Helm charts
7. **Testing**: Validate functionality
8. **Cutover**: Update DNS/routing

## Conclusion

Both platforms can run the same Flowable workloads using Kubernetes. The choice depends on:
- Business requirements
- Cost considerations
- Technical expertise
- Compliance needs
- Existing infrastructure

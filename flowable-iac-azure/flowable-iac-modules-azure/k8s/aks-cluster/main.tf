/**
  * # Azure - K8s - AKS Cluster
  * 
  * This a Terraform module for a Kubernetes Cluster on Azure Kubernetes Service (AKS).
  * See the documentation below for additional info on using this module.
  */

# Generate the names for the AKS Virtual Network
resource "azurecaf_name" "aks_name" {
  resource_type = "azurerm_kubernetes_cluster"
  name          = var.cluster_name
  suffixes      = [var.env_suffix]
}

resource "azurecaf_name" "vn_name" {
  resource_type = "azurerm_virtual_network"
  name          = var.cluster_name
  suffixes      = [var.env_suffix]
}

resource "azurecaf_name" "pool_name_system" {
  resource_type = "aks_node_pool_linux"
  name          = "flwproduct"
  prefixes      = ["system"]
  suffixes      = [var.env_suffix]
}

# Define the VNET where nodes will be connected, as well 
# as other resources like DBs
resource "azurerm_virtual_network" "vnet" {
  name                = azurecaf_name.vn_name.result
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group_name
  address_prefixes     = ["10.1.0.0/22"]

  # Virtual Network (VNet) service endpoint configuration
  service_endpoints = var.aks_vnet_service_endpoints
}

# The AKS cluster resource, with a default node pool for internal workloads
# (critical addons) and additional pools for devops workloads (argocd, monitoring)
# and user workloads (the applications that will run in this cluster)
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = azurecaf_name.aks_name.result
  dns_prefix          = azurecaf_name.aks_name.result
  location            = var.location
  resource_group_name = var.resource_group_name
  kubernetes_version  = var.kubernetes_version
  sku_tier            = var.sku_tier

  default_node_pool {
    name                = var.system_node_pool_name
    vm_size             = var.system_node_pool_vm_size
    enable_auto_scaling = var.system_node_pool_enable_auto_scaling

    # Max/min nodes variables are set to null if auto_scaling is disabled
    min_count            = var.system_node_pool_enable_auto_scaling ? var.system_node_pool_node_count_min : null
    max_count            = var.system_node_pool_enable_auto_scaling ? var.system_node_pool_node_count_max : null
    node_count           = var.system_node_pool_node_count
    zones                = var.system_node_pool_zones
    max_pods             = var.system_node_pool_max_pods
    os_disk_size_gb      = var.system_node_pool_os_disk_size_gb
    os_disk_type         = var.system_node_pool_os_disk_type
    orchestrator_version = var.kubernetes_version
    vnet_subnet_id       = azurerm_subnet.internal.id

    only_critical_addons_enabled = "true"
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "calico"
    load_balancer_sku = "standard"
  }

  auto_scaler_profile {
    # How long a node should be unneeded before it is eligible for scale down. 
    scale_down_unneeded = "10m"

    # Node utilization level, defined as sum of requested resources divided by
    # capacity, below which a node can be considered for scale down.
    scale_down_utilization_threshold = "0.5"

    # If true cluster autoscaler will never delete nodes with pods with local
    # storage, for example, EmptyDir or HostPath.
    skip_nodes_with_local_storage = "false"

    # If true cluster autoscaler will never delete nodes with pods from
    # kube-system (except for DaemonSet or mirror pods)/
    skip_nodes_with_system_pods = "false"

    # Maximum number of empty nodes that can be deleted at the same time.
    empty_bulk_delete_max = "1"
  }

  # Enable RBAC and integrate with AAD
  role_based_access_control_enabled = "true"

  azure_active_directory_role_based_access_control {
    #   // Auto-create/manage service principal that is used for RBAC-AAD-auth
    managed                = true
    admin_group_object_ids = var.admin_group_object_ids
    azure_rbac_enabled     = true
  }

  # The auto-managed service principal used by K8s to talk to the Azure API
  identity {
    type = "SystemAssigned"
  }

  # Prevent deletion of the resource with Terraform
  lifecycle {
    prevent_destroy = true
    ignore_changes  = [default_node_pool[0].node_count]
  }
}

# Create a lock to prevent deletion in Azure Portal
resource "azurerm_management_lock" "aks_cluster_lock" {
  name       = "aks_cluster_lock"
  scope      = azurerm_kubernetes_cluster.aks_cluster.id
  lock_level = "CanNotDelete"
  notes      = "Locked because it's a critical resource"
}

# Default node pools

resource "azurerm_kubernetes_cluster_node_pool" "user1" {
  name                  = var.user_node_pool_name
  vm_size               = var.user_node_pool_vm_size
  enable_auto_scaling   = var.user_node_pool_enable_auto_scaling
  zones                 = var.user_node_pool_zones
  max_pods              = var.user_node_pool_max_pods
  os_disk_size_gb       = var.user_node_pool_os_disk_size_gb
  os_disk_type          = var.user_node_pool_os_disk_type
  orchestrator_version  = var.kubernetes_version
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  vnet_subnet_id        = azurerm_subnet.internal.id
  os_type               = "Linux"
  # node_taints           = ["${var.user_node_pool_taints}"]

  # Max/min nodes variables are set to null if auto_scaling is disabled
  min_count  = var.user_node_pool_enable_auto_scaling ? var.user_node_pool_node_count_min : null
  max_count  = var.user_node_pool_enable_auto_scaling ? var.user_node_pool_node_count_max : null
  node_count = var.user_node_pool_node_count

  lifecycle {
    ignore_changes = [
      node_count,
    ]
  }
}
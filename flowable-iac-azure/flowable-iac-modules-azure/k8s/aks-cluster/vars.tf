variable "location" {
  description = "Location of the AKS cluster"
  type        = string
}

variable "cluster_name" {
  description = "Base name of the AKS cluster"
  type        = string
}

variable "env_suffix" {
  description = "Environment suffix of the AKS cluster"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group where the cluster will be created"
  type        = string
}

variable "cluster_domain" {
  description = "Global domain for this cluster's services URLs"
  type        = string
  default     = "defaultsubdomain.flowable.io"
}

variable "kubernetes_version" {
  description = "Version of k8s used in the cluster"
  type        = string
  default     = "1.25.5"
}

variable "sku_tier" {
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid (which includes the Uptime SLA, for prod envs). Defaults to Free."
  type        = string
  default     = "Free"
}

variable "admin_group_object_ids" {
  description = "Ids of the AAD groups granted Admin privileges on this cluster"
  type        = list(string)
  default     = ["7ffce725-6174-4575-b875-a7066700cb75"] # internal-buildeng-flowable-product
}

variable "aks_vnet_service_endpoints" {
  description = "Endpoints configured in the internal VNET to provide direct connectivity to Azure services.Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage and Microsoft.Web."
  type        = list(any)
  default     = null
}

# System pool variables
variable "system_node_pool_name" {
  description = "Name of the default node pool"
  type        = string
}

variable "system_node_pool_enable_auto_scaling" {
  description = "Enable auto scaling for this node pool"
  type        = bool
  default     = false
}

variable "system_node_pool_node_count_min" {
  description = "Number of nodes in this node pool (when auto scaling is enabled this is will be the initial node pool size)"
  type        = number
  default     = 1
}

variable "system_node_pool_node_count_max" {
  description = "Number of nodes in this node pool (when auto scaling is enabled this is will be the maximum node pool size)"
  type        = number
  default     = 1
}

variable "system_node_pool_node_count" {
  description = "Number of nodes in this node pool (when auto scaling is disabled this is will be the fix node pool size)"
  type        = number
  default     = 1
}

variable "system_node_pool_max_pods" {
  description = "Max pods per node in this node pool"
  type        = number
  default     = 100
}

variable "system_node_pool_vm_size" {
  description = "Logical descriptor of the Virtual Machine size. See https://docs.microsoft.com/nl-nl/azure/virtual-machines/sizes for more info."
  type        = string
  default     = "Standard_D2_v2"
}

variable "system_node_pool_zones" {
  description = "Azure Zones where clusters will start VMs"
  type        = list(any)
  default     = [1, 2, 3]
}

variable "system_node_pool_os_disk_size_gb" {
  description = "Size of the OS disk in GB"
  type        = number
  default     = 30
}

variable "user_node_pool_os_disk_type" {
  description = "The type of disk which should be used for the Operating System. Possible values are Ephemeral and Managed."
  type        = string
  default     = "Ephemeral"
}

# User pool (for application workloads) variables
variable "user_node_pool_name" {
  description = "Name of the default node pool"
  type        = string
}

variable "user_node_pool_enable_auto_scaling" {
  description = "Enable auto scaling for this node pool"
  default     = false
  type        = bool
}

variable "user_node_pool_node_count_min" {
  description = "Number of nodes in this node pool (when auto scaling is enabled this is will be the initial node pool size)"
  type        = number
  default     = 1
}

variable "user_node_pool_node_count_max" {
  description = "Number of nodes in this node pool (when auto scaling is enabled this is will be the maximum node pool size)"
  type        = number
  default     = 1
}

variable "user_node_pool_node_count" {
  description = "Number of nodes in this node pool (when auto scaling is disabled this is will be the fix node pool size)"
  type        = number
  default     = 1
}

variable "user_node_pool_max_pods" {
  description = "Max pods per node in this node pool"
  type        = number
  default     = 100
}

variable "user_node_pool_vm_size" {
  description = "Logical descriptor of the Virtual Machine size. See https://docs.microsoft.com/nl-nl/azure/virtual-machines/sizes for more info."
  type        = string
  default     = "Standard_D2_v2"
}

variable "user_node_pool_zones" {
  description = "Azure Zones where clusters will start VMs"
  type        = list(any)
  default     = [1, 2, 3]
}

variable "user_node_pool_os_disk_size_gb" {
  description = "Size of the OS disk in GB"
  type        = number
  default     = "30"
}

variable "system_node_pool_os_disk_type" {
  description = "The type of disk which should be used for the Operating System. Possible values are Ephemeral and Managed."
  type        = string
  default     = "Ephemeral"
}

variable "user_node_pool_taints" {
  description = "Taints configured for this pool. Used to control workloads running in these nodes."
  default     = ""
  type        = string
}

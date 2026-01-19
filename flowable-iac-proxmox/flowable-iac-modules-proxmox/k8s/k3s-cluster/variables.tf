variable "cluster_name" {
  description = "Name of the K3s cluster"
  type        = string
}

variable "env_suffix" {
  description = "Environment suffix"
  type        = string
}

variable "resource_pool_name" {
  description = "Name of the Proxmox resource pool"
  type        = string
}

variable "node_name" {
  description = "Proxmox node name where VMs will be created"
  type        = string
  default     = "pve"
}

variable "kubernetes_version" {
  description = "Kubernetes version for K3s"
  type        = string
  default     = "v1.27.3+k3s1"
}

variable "master_count" {
  description = "Number of master nodes"
  type        = number
  default     = 1
}

variable "master_vm_cpu" {
  description = "Number of CPUs for master nodes"
  type        = number
  default     = 2
}

variable "master_vm_memory" {
  description = "Memory in MB for master nodes"
  type        = number
  default     = 4096
}

variable "master_vm_disk_size" {
  description = "Disk size in GB for master nodes"
  type        = number
  default     = 32
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

variable "worker_vm_cpu" {
  description = "Number of CPUs for worker nodes"
  type        = number
  default     = 4
}

variable "worker_vm_memory" {
  description = "Memory in MB for worker nodes"
  type        = number
  default     = 8192
}

variable "worker_vm_disk_size" {
  description = "Disk size in GB for worker nodes"
  type        = number
  default     = 64
}

variable "vm_template_id" {
  description = "Template ID for VM cloning (Ubuntu cloud-init template)"
  type        = number
  default     = 9000
}

variable "storage_name" {
  description = "Storage name for VM disks"
  type        = string
  default     = "local-lvm"
}

variable "network_bridge" {
  description = "Network bridge for VMs"
  type        = string
  default     = "vmbr0"
}

variable "ssh_keys" {
  description = "SSH public keys for VM access"
  type        = list(string)
  default     = []
}

variable "vlan_tag" {
  description = "VLAN tag for network isolation"
  type        = number
  default     = null
}

variable "db_server_name" {
  description = "Name of the PostgreSQL server"
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
  description = "Proxmox node name"
  type        = string
  default     = "pve"
}

variable "vm_cpu" {
  description = "Number of CPUs"
  type        = number
  default     = 4
}

variable "vm_memory" {
  description = "Memory in MB"
  type        = number
  default     = 8192
}

variable "vm_disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 100
}

variable "vm_template_id" {
  description = "Template ID for VM cloning"
  type        = number
  default     = 9000
}

variable "storage_name" {
  description = "Storage name for VM disks"
  type        = string
  default     = "local-lvm"
}

variable "network_bridge" {
  description = "Network bridge"
  type        = string
  default     = "vmbr0"
}

variable "ssh_keys" {
  description = "SSH public keys"
  type        = list(string)
  default     = []
}

variable "vlan_tag" {
  description = "VLAN tag"
  type        = number
  default     = null
}

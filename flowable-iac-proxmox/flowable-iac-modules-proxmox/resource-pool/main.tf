/**
  * # Proxmox - Resource Pool
  * 
  * This is a Terraform module for creating a resource pool on Proxmox.
  * Resource pools help organize and manage VMs and containers.
  */

# Create a resource pool
resource "proxmox_virtual_environment_pool" "pool" {
  pool_id = "${var.name}-${var.env_suffix}"
  comment = var.comment != "" ? var.comment : "Resource pool for ${var.name} (${var.env_suffix})"
}

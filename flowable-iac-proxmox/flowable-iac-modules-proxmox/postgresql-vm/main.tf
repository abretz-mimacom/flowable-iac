/**
  * # Proxmox - PostgreSQL VM
  * 
  * This is a Terraform module for creating a PostgreSQL database server VM on Proxmox.
  */

locals {
  db_full_name = "${var.db_server_name}-${var.env_suffix}"
}

# Create PostgreSQL VM
resource "proxmox_virtual_environment_vm" "postgres" {
  name        = local.db_full_name
  description = "PostgreSQL database server for ${local.db_full_name}"
  node_name   = var.node_name
  pool_id     = var.resource_pool_name

  clone {
    vm_id = var.vm_template_id
    full  = true
  }

  cpu {
    cores = var.vm_cpu
    type  = "host"
  }

  memory {
    dedicated = var.vm_memory
  }

  disk {
    datastore_id = var.storage_name
    interface    = "scsi0"
    size         = var.vm_disk_size
  }

  network_device {
    bridge  = var.network_bridge
    vlan_id = var.vlan_tag
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = "ubuntu"
      keys     = var.ssh_keys
    }
  }

  on_boot = true

  tags = ["postgresql", "database", var.env_suffix]
}

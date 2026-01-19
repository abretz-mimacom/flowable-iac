/**
  * # Proxmox - K8s - K3s Cluster
  * 
  * This is a Terraform module for creating a K3s Kubernetes cluster on Proxmox.
  * K3s is a lightweight Kubernetes distribution perfect for edge and IoT scenarios.
  */

locals {
  cluster_full_name = "${var.cluster_name}-${var.env_suffix}"
}

# Create K3s master nodes
resource "proxmox_virtual_environment_vm" "k3s_master" {
  count = var.master_count

  name        = "${local.cluster_full_name}-master-${count.index + 1}"
  description = "K3s master node ${count.index + 1} for ${local.cluster_full_name}"
  node_name   = var.node_name
  pool_id     = var.resource_pool_name

  clone {
    vm_id = var.vm_template_id
    full  = true
  }

  cpu {
    cores = var.master_vm_cpu
    type  = "host"
  }

  memory {
    dedicated = var.master_vm_memory
  }

  disk {
    datastore_id = var.storage_name
    interface    = "scsi0"
    size         = var.master_vm_disk_size
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

  tags = ["k3s", "master", var.env_suffix]
}

# Create K3s worker nodes
resource "proxmox_virtual_environment_vm" "k3s_worker" {
  count = var.worker_count

  name        = "${local.cluster_full_name}-worker-${count.index + 1}"
  description = "K3s worker node ${count.index + 1} for ${local.cluster_full_name}"
  node_name   = var.node_name
  pool_id     = var.resource_pool_name

  clone {
    vm_id = var.vm_template_id
    full  = true
  }

  cpu {
    cores = var.worker_vm_cpu
    type  = "host"
  }

  memory {
    dedicated = var.worker_vm_memory
  }

  disk {
    datastore_id = var.storage_name
    interface    = "scsi0"
    size         = var.worker_vm_disk_size
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

  tags = ["k3s", "worker", var.env_suffix]
}

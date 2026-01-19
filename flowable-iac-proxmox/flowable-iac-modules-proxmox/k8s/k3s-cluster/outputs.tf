output "cluster_name" {
  description = "The name of the K3s cluster"
  value       = local.cluster_full_name
}

output "master_vm_ids" {
  description = "IDs of the master VMs"
  value       = proxmox_virtual_environment_vm.k3s_master[*].vm_id
}

output "worker_vm_ids" {
  description = "IDs of the worker VMs"
  value       = proxmox_virtual_environment_vm.k3s_worker[*].vm_id
}

output "master_ips" {
  description = "IP addresses of master nodes"
  value       = proxmox_virtual_environment_vm.k3s_master[*].ipv4_addresses
}

output "worker_ips" {
  description = "IP addresses of worker nodes"
  value       = proxmox_virtual_environment_vm.k3s_worker[*].ipv4_addresses
}

output "resource_pool_name" {
  description = "The resource pool name"
  value       = var.resource_pool_name
}

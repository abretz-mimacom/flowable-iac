output "vm_id" {
  description = "The VM ID of the PostgreSQL server"
  value       = proxmox_virtual_environment_vm.postgres.vm_id
}

output "db_server_name" {
  description = "The name of the PostgreSQL server"
  value       = local.db_full_name
}

output "vm_ip" {
  description = "IP address of the PostgreSQL server"
  value       = proxmox_virtual_environment_vm.postgres.ipv4_addresses
}

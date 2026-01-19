output "db_server_fqdn" {
  value = data.azurerm_postgresql_flexible_server.flowable.fqdn
}

output "db_server_name" {
  value = data.azurerm_postgresql_flexible_server.flowable.name
}

output "db_server_id" {
  value = data.azurerm_postgresql_flexible_server.flowable.id
}

output "db_server_resource_group_name" {
  value = data.azurerm_postgresql_flexible_server.flowable.resource_group_name
}
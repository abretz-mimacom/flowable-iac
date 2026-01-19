/**
  * # Azure - PostgreSQL Managed - Database
  * 
  * This a Terraform module for deploying a Azure managed PostgreSQL service databases.
  * See the documentation below for additional info on using this module.
  */

resource "azurerm_postgresql_flexible_server_database" "database" {
  for_each = var.databases

  name      = each.key
  server_id = lookup(each.value, "db_server_id", null)
  charset   = lookup(each.value, "charset", "utf8")
  collation = lookup(each.value, "collation", "en_US.utf8")
}

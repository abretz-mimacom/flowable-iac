/**
  * # Azure - PostgreSQL Managed Flexible Server
  * 
  * This a Terraform module for deploying a Azure managed PostgreSQL flexible server service.
  * See the documentation below for additional info on using this module.
  */

# DB username and passwords are secrets stored in a KeyVault
data "azurerm_key_vault" "keyvault" {
  name                = var.keyvault_name
  resource_group_name = var.keyvault_resource_group_name
}

data "azurerm_key_vault_secret" "flowable_db_username" {
  name         = var.keyvault_secret_name_flowable_db_username
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

data "azurerm_key_vault_secret" "flowable_db_password" {
  name         = var.keyvault_secret_name_flowable_db_password
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

# DB Server will be connected to a subnet of an existing virtual network
resource "azurecaf_name" "vn_name" {
  resource_type = "azurerm_virtual_network"
  name          = var.cluster_name
  suffixes      = [var.env_suffix]
}
data "azurerm_virtual_network" "flw_vnet" {
  name                = azurecaf_name.vn_name.result
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "flw_db" {
  name                 = "sn-flowable-db"
  resource_group_name  = var.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.flw_vnet.name
  address_prefixes     = ["10.1.4.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

# Private DNS zone is required to resolve the address of the DB server
# within the internal subnet
resource "azurerm_private_dns_zone" "flw_db" {
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "flw_db" {
  name                  = "flwVnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.flw_db.name
  virtual_network_id    = data.azurerm_virtual_network.flw_vnet.id
  resource_group_name   = var.resource_group_name
}

# The actual PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "flowable" {
  name                         = var.db_server_name
  location                     = var.resource_group_location
  resource_group_name          = var.resource_group_name
  sku_name                     = var.db_sku_name
  storage_mb                   = var.db_storage_mb
  backup_retention_days        = var.db_backup_retention_days
  geo_redundant_backup_enabled = var.db_geo_redundant_backup_enabled
  administrator_login          = data.azurerm_key_vault_secret.flowable_db_username.value
  administrator_password       = data.azurerm_key_vault_secret.flowable_db_password.value
  version                      = var.db_version
  delegated_subnet_id          = azurerm_subnet.flw_db.id
  private_dns_zone_id          = azurerm_private_dns_zone.flw_db.id
  zone                         = var.zone
  depends_on                   = [azurerm_private_dns_zone_virtual_network_link.flw_db]

  # if ha_enabled is true, create an HA instance 
  dynamic "high_availability" {
    for_each = var.ha_enabled ? ["flowable_standby"] : []
    content {
      mode                      = var.ha_mode
      standby_availability_zone = var.zone_standby_server
    }
  }
  maintenance_window {
    day_of_week  = var.maintenance_window_day
    start_hour   = var.maintenance_window_start_hour
    start_minute = var.maintenance_window_start_minute
  }

  # Prevent deletion Terraform
  # lifecycle {
  #   prevent_destroy = true
  #   ignore_changes = [
  #     zone,
  #     high_availability.0.standby_availability_zone
  #   ]
  # }
}

# PostgreSQL configuration
resource "azurerm_postgresql_flexible_server_configuration" "flowable_psql_max_connections" {
  name      = "max_connections"
  server_id = azurerm_postgresql_flexible_server.flowable.id
  value     = var.psql_max_connections
}

data "azurerm_postgresql_flexible_server" "flowable" {
  name                = azurerm_postgresql_flexible_server.flowable.name
  resource_group_name = azurerm_postgresql_flexible_server.flowable.resource_group_name
}

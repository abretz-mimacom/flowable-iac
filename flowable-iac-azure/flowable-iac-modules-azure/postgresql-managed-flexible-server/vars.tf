variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "resource_group_location" {
  description = "Location of the resource group"
  type        = string
}

variable "db_server_name" {
  description = "Name of the Flowable DB server"
  type        = string
}

variable "zone" {
  description = "Zone of the Flowable DB server"
  type        = string
  default     = "1"
}

variable "ha_enabled" {
  description = "Set to true to enable HA. This will configure a standby server"
  type        = bool
  default     = false
}

variable "ha_mode" {
  description = "The high availability mode for the PostgreSQL Flexible Server. Possible value are SameZone or ZoneRedundant."
  type = string
  default = "SameZone"
}

variable "zone_standby_server" {
  description = "Zone of the Flowable DB standby server"
  type        = string
  default     = "2"
}

variable "maintenance_window_day" {
  description = "The day of week for maintenance window, where the week starts on a Sunday, i.e. Sunday = 0, Monday = 1. Defaults to 0."
  type        = string
  default     = "6"
}

variable "maintenance_window_start_hour" {
  description = "The start hour for maintenance window. Defaults to 0"
  type        = string
  default     = "0"
}

variable "maintenance_window_start_minute" {
  description = "The minute hour for maintenance window. Defaults to 0"
  type        = string
  default     = "0"
}

variable "psql_max_connections" {
  description = "Parameter max_connections of PosgreSQL server. Default is 100"
  type        = string
  default     = "100"
}
variable "db_sku_name" {
  description = "Specifies the SKU Name for this PostgreSQL Server. The name of the SKU, follows the tier + family + cores pattern (e.g. B_Gen4_1, GP_Gen5_8)"
  type        = string
  default     = "B_Gen5_2"
}

variable "db_storage_mb" {
  description = "Max storage allowed for a server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 16777216 MB(16TB) for General Purpose/Memory Optimized SKUs. For more information see the product documentation"
  type        = number
  default     = 5120
}

variable "db_backup_retention_days" {
  description = "Backup retention days for the server, supported values are between 7 and 35 days"
  type        = number
  default     = 7
}

variable "db_geo_redundant_backup_enabled" {
  description = "Turn Geo-redundant server backups on/off. Not supported for the Basic tier"
  type        = bool
  default     = false
}

variable "db_version" {
  description = "Specifies the version of PostgreSQL to use. Valid values are 9.5, 9.6, 10, 10.0, and 11"
  type        = string
  default     = "14"
}

variable "cluster_name" {
  description = "Then name of kubernetes cluster"
  type        = string
}

variable "env_suffix" {
  description = "Environment suffix of the AKS cluster"
  type        = string
}

variable "dns_zone_name" {
  description = "DNS Zone name"
  type        = string
}

variable "keyvault_resource_group_name" {
  description = "Name of the credentials keyvault resource group"
  type        = string
}

variable "keyvault_name" {
  description = "Name of the credentials keyvault"
  type        = string
}

variable "keyvault_secret_name_flowable_db_username" {
  description = "Name of the Azure keyvault secret which holds the Flowable db username"
  type        = string
}

variable "keyvault_secret_name_flowable_db_password" {
  description = "Name of the Azure keyvault secret which holds the Flowable db password"
  type        = string
}

variable "db_k8s_firewall_rule_name" {
  description = "Name of the firewall rule between the Kubernetes cluster and the DB server"
  type        = string
  default     = "flowable-db-k8s"
}

variable "db_k8s_firewall_rule_start_ip" {
  description = "Start IP address for the firewall rule"
  type        = string
  default     = "0.0.0.0"
}

variable "db_k8s_firewall_rule_end_ip" {
  description = "End IP address for the firewall rule"
  type        = string
  default     = "0.0.0.0"
}

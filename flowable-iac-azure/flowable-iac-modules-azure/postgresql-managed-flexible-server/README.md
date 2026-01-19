<!-- BEGIN_TF_DOCS -->
# Azure - PostgreSQL Managed Flexible Server

This a Terraform module for deploying a Azure managed PostgreSQL flexible server service.
See the documentation below for additional info on using this module.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | ~> 1.2.20 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.22 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurecaf"></a> [azurecaf](#provider\_azurecaf) | ~> 1.2.20 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.22 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurecaf_name.vn_name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurerm_management_lock.psql_flexible_server_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_postgresql_flexible_server.flowable](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server) | resource |
| [azurerm_postgresql_flexible_server_configuration.flowable_psql_max_connections](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration) | resource |
| [azurerm_private_dns_zone.flw_db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.flw_db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_subnet.flw_db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_key_vault.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.flowable_db_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.flowable_db_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_postgresql_flexible_server.flowable](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/postgresql_flexible_server) | data source |
| [azurerm_virtual_network.flw_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Then name of kubernetes cluster | `string` | n/a | yes |
| <a name="input_db_backup_retention_days"></a> [db\_backup\_retention\_days](#input\_db\_backup\_retention\_days) | Backup retention days for the server, supported values are between 7 and 35 days | `number` | `7` | no |
| <a name="input_db_geo_redundant_backup_enabled"></a> [db\_geo\_redundant\_backup\_enabled](#input\_db\_geo\_redundant\_backup\_enabled) | Turn Geo-redundant server backups on/off. Not supported for the Basic tier | `bool` | `false` | no |
| <a name="input_db_k8s_firewall_rule_end_ip"></a> [db\_k8s\_firewall\_rule\_end\_ip](#input\_db\_k8s\_firewall\_rule\_end\_ip) | End IP address for the firewall rule | `string` | `"0.0.0.0"` | no |
| <a name="input_db_k8s_firewall_rule_name"></a> [db\_k8s\_firewall\_rule\_name](#input\_db\_k8s\_firewall\_rule\_name) | Name of the firewall rule between the Kubernetes cluster and the DB server | `string` | `"flowable-db-k8s"` | no |
| <a name="input_db_k8s_firewall_rule_start_ip"></a> [db\_k8s\_firewall\_rule\_start\_ip](#input\_db\_k8s\_firewall\_rule\_start\_ip) | Start IP address for the firewall rule | `string` | `"0.0.0.0"` | no |
| <a name="input_db_server_name"></a> [db\_server\_name](#input\_db\_server\_name) | Name of the Flowable DB server | `string` | n/a | yes |
| <a name="input_db_sku_name"></a> [db\_sku\_name](#input\_db\_sku\_name) | Specifies the SKU Name for this PostgreSQL Server. The name of the SKU, follows the tier + family + cores pattern (e.g. B\_Gen4\_1, GP\_Gen5\_8) | `string` | `"B_Gen5_2"` | no |
| <a name="input_db_storage_mb"></a> [db\_storage\_mb](#input\_db\_storage\_mb) | Max storage allowed for a server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 16777216 MB(16TB) for General Purpose/Memory Optimized SKUs. For more information see the product documentation | `number` | `5120` | no |
| <a name="input_db_version"></a> [db\_version](#input\_db\_version) | Specifies the version of PostgreSQL to use. Valid values are 9.5, 9.6, 10, 10.0, and 11 | `string` | `"14"` | no |
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | DNS Zone name | `string` | n/a | yes |
| <a name="input_env_suffix"></a> [env\_suffix](#input\_env\_suffix) | Environment suffix of the AKS cluster | `string` | n/a | yes |
| <a name="input_ha_enabled"></a> [ha\_enabled](#input\_ha\_enabled) | Set to true to enable HA. This will configure a standby server in another zone | `bool` | `false` | no |
| <a name="input_keyvault_name"></a> [keyvault\_name](#input\_keyvault\_name) | Name of the credentials keyvault | `string` | n/a | yes |
| <a name="input_keyvault_resource_group_name"></a> [keyvault\_resource\_group\_name](#input\_keyvault\_resource\_group\_name) | Name of the credentials keyvault resource group | `string` | n/a | yes |
| <a name="input_keyvault_secret_name_flowable_db_password"></a> [keyvault\_secret\_name\_flowable\_db\_password](#input\_keyvault\_secret\_name\_flowable\_db\_password) | Name of the Azure keyvault secret which holds the Flowable db password | `string` | n/a | yes |
| <a name="input_keyvault_secret_name_flowable_db_username"></a> [keyvault\_secret\_name\_flowable\_db\_username](#input\_keyvault\_secret\_name\_flowable\_db\_username) | Name of the Azure keyvault secret which holds the Flowable db username | `string` | n/a | yes |
| <a name="input_maintenance_window_day"></a> [maintenance\_window\_day](#input\_maintenance\_window\_day) | The day of week for maintenance window, where the week starts on a Sunday, i.e. Sunday = 0, Monday = 1. Defaults to 0. | `string` | `"6"` | no |
| <a name="input_maintenance_window_start_hour"></a> [maintenance\_window\_start\_hour](#input\_maintenance\_window\_start\_hour) | The start hour for maintenance window. Defaults to 0 | `string` | `"0"` | no |
| <a name="input_maintenance_window_start_minute"></a> [maintenance\_window\_start\_minute](#input\_maintenance\_window\_start\_minute) | The start hour for maintenance window. Defaults to 0 | `string` | `"0"` | no |
| <a name="input_psql_max_connections"></a> [psql\_max\_connections](#input\_psql\_max\_connections) | Parameter max\_connections of PosgreSQL server | `string` | `"50"` | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Location of the resource group | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Zone of the Flowable DB server | `string` | `"1"` | no |
| <a name="input_zone_standby_server"></a> [zone\_standby\_server](#input\_zone\_standby\_server) | Zone of the Flowable DB standby server | `string` | `"2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_server_fqdn"></a> [db\_server\_fqdn](#output\_db\_server\_fqdn) | n/a |
| <a name="output_db_server_id"></a> [db\_server\_id](#output\_db\_server\_id) | n/a |
| <a name="output_db_server_name"></a> [db\_server\_name](#output\_db\_server\_name) | n/a |
| <a name="output_db_server_resource_group_name"></a> [db\_server\_resource\_group\_name](#output\_db\_server\_resource\_group\_name) | n/a |
<!-- END_TF_DOCS -->
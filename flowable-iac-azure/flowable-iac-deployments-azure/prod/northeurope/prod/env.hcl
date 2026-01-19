# Set common variables for the environment. This is automatically pulled in in the root terragrunt root.hcl configuration to
# feed forward to the child modules.
locals {
  env_suffix                                      = "prod"
  namespace                                       = "flowable-iac-prod"
  state_storage_resource_group_name               = "rg-flowable-iac-sec"
  state_storage_account_name                      = "stflowableiactfstate"
  state_storage_container_name                    = "tfstate"
  keyvault_name                                   = "kv-flowable-iac-prod"
  keyvault_resource_group_name                    = "rg-flowable-iac-sec"
  keyvault_secret_name_flowable_repo_username     = "flowable-repo-username"
  keyvault_secret_name_flowable_repo_password     = "flowable-repo-password"
  keyvault_secret_name_flowable_db_username       = "flowable-db-username"
  keyvault_secret_name_flowable_db_password       = "flowable-db-password"
  keyvault_secret_name_flowable_db_admin_password = "flowable-db-admin-password"
  keyvault_secret_name_flowable_license           = "flowable-license"

    # AKS CLUSTER VARS
  cluster_name                          = "flowable-iac" // env suffix will be added
  cluster_domain                        = "flowable-iac-prod.flowable.io"
  kubernetes_version                    = "1.27.3"
  aks_vnet_service_endpoints            = ["Microsoft.Storage"]
  admin_group_object_ids                = [] 
  
  system_node_pool_name                 = "systempool"
  system_node_pool_vm_size              = "Standard_D2ads_v5"
  system_node_pool_enable_auto_scaling  = false
  # system_node_pool_node_count_min       = 1
  # system_node_pool_node_count_max       = 1
  system_node_pool_node_count           = 2
  system_node_pool_zones                = [1, 2, 3]
  system_node_pool_max_pods             = 100
  system_node_pool_os_disk_size_gb      = 30

  user_node_pool_name                   = "user"
  user_node_pool_vm_size                = "Standard_F8s_v2"
  user_node_pool_enable_auto_scaling    = true
  user_node_pool_node_count_min         = 1                 
  user_node_pool_node_count_max         = 3
  user_node_pool_os_disk_size_gb        = 30
  user_node_pool_max_pods               = 100
  user_node_pool_zones                  = [1,2,3]

  # POSTGRESQL SERVER VARS
  db_server_name                        = "flowable-iac-prod-postgres"
  dns_zone_name                         = "flowable-iac-prod.postgres.database.azure.com"
  db_geo_redundant_backup_enabled       = true
  db_sku_name                           = "GP_Standard_D2ds_v4" 
  db_backup_retention_days              = 7
  db_storage_mb                         = 32768
  db_k8s_firewall_rule_name             = "flowable-iac-prod-k8s-db"
}
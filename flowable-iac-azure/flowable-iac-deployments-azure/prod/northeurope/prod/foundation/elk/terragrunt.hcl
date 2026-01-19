# Include the root terragrunt `root.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include {
  path = find_in_parent_folders("root.hcl")
}

# Reference the ELK module
terraform {
  source = "../../../../../../flowable-iac-modules-azure/elk"
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  
  # Extract namespace
  namespace = local.environment_vars.locals.namespace
}

dependency "aks_cluster" {
  config_path = "../k8s/aks-cluster"
}

inputs = {
  cluster_name                = dependency.aks_cluster.outputs.cluster_name
  cluster_resource_group_name = dependency.aks_cluster.outputs.cluster_resource_group_name
  release_namespace           = "${local.namespace}-elk"
  
  # Production environment configuration - higher resources and replicas
  elasticsearch_replicas      = 3
  elasticsearch_storage_size  = "50Gi"
  elasticsearch_storage_class = "managed-premium"
  
  elasticsearch_resources_requests_cpu    = "1000m"
  elasticsearch_resources_requests_memory = "2Gi"
  elasticsearch_resources_limits_cpu      = "2000m"
  elasticsearch_resources_limits_memory   = "4Gi"
  elasticsearch_heap_size                 = "2g"  # Half of memory limit
  
  kibana_replicas = 2
}

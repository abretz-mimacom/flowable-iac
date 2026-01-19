# Include the root terragrunt `root.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include {
  path = find_in_parent_folders("root.hcl")
}

# We override the terraform block source attribute here just for the QA environment to show how you would deploy a
# different version of the module in a specific environment.
terraform {
  source = "../../../../../../flowable-iac-modules-azure/flowable-app"
}

locals {
  # Automatically load environment-level variables
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  app_vars         = read_terragrunt_config(find_in_parent_folders("app.hcl"))

  # Extract out common variables for reuse
  workload            = local.account_vars.locals.workload
  env_suffix          = local.environment_vars.locals.env_suffix
  namespace           = local.environment_vars.locals.namespace
  region              = local.region_vars.locals.region

  es_enabled          = local.app_vars.locals.es_enabled ? true : false

  db_server_name          = local.environment_vars.locals.db_server_name

  flowable_control_enabled    = local.app_vars.locals.flowable_control_enabled ? true : false
  flowable_design_enabled     = local.app_vars.locals.flowable_design_enabled ? true : false
  flowable_work_enabled       = local.app_vars.locals.flowable_work_enabled ? true : false
  flowable_engage_enabled     = local.app_vars.locals.flowable_engage_enabled ? true : false
}

dependencies {
  paths = ["../../foundation/k8s/ingress-nginx", "../postgres-flexible-databases", "../../foundation/elk"]
}

dependency "k8s" {
  config_path = "../../foundation/k8s/aks-cluster"
}

dependency "elk" {
  config_path = "../../foundation/elk"
  skip_outputs = !local.es_enabled
}

inputs = {
  cluster_name                = dependency.k8s.outputs.cluster_name
  cluster_resource_group_name = dependency.k8s.outputs.cluster_resource_group_name
  release_name                = local.workload
  release_namespace           = local.namespace
  chart_name                  = "flowable"
  chart_version               = "3.14.4-beta.2"

  values = templatefile("values.yaml", {
    ingress_domain                      = "${local.workload}-${local.env_suffix}.${local.region}.cloudapp.azure.com"
    flowable_indexing_index-name-prefix = "${local.workload}-",
    es_enabled                          = local.es_enabled,
    es_rest_uris                        = local.es_enabled ? "http://${dependency.elk.outputs.elasticsearch_endpoint}" : "",
    flowable_control_enabled            = local.flowable_control_enabled,
    flowable_design_enabled             = local.flowable_design_enabled,
    flowable_work_enabled               = local.flowable_work_enabled,
    flowable_engage_enabled             = local.flowable_engage_enabled,
    flowable_control_jdbc               = "jdbc:postgresql://${local.db_server_name}.postgres.database.azure.com:5432/flw_control_db?sslmode=require",
    flowable_design_jdbc                = "jdbc:postgresql://${local.db_server_name}.postgres.database.azure.com:5432/flw_design_db?sslmode=require",
    flowable_work_jdbc                  = "jdbc:postgresql://${local.db_server_name}.postgres.database.azure.com:5432/flw_work_db?sslmode=require",
    flowable_engage_jdbc                = "jdbc:postgresql://${local.db_server_name}.postgres.database.azure.com:5432/flw_engage_db?sslmode=require",
  })
}
  
# Include the root terragrunt `root.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include {
  path = find_in_parent_folders("root.hcl")
}

# We override the terraform block source attribute here just for the QA environment to show how you would deploy a
# different version of the module in a specific environment.
terraform {
  source = "../../../../../../../flowable-iac-modules-azure//k8s/ingress-nginx"
}

locals {
  # Automatically load environment-level variables
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  workload            = local.account_vars.locals.workload
  env_suffix          = local.environment_vars.locals.env_suffix
}

dependency "aks_cluster" {
  config_path = "../aks-cluster"
}

inputs = {
  cluster_name                = dependency.aks_cluster.outputs.cluster_name
  cluster_resource_group_name = dependency.aks_cluster.outputs.cluster_resource_group_name
  azure_dns_label             = "${local.workload}-${local.env_suffix}"
}
  
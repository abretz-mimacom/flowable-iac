# Include the root terragrunt `root.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include {
  path = find_in_parent_folders("root.hcl")
}

# We reference the source of the module to be used in this environment
terraform {
  source = "../../../../../../flowable-iac-modules-azure/postgresql-managed-flexible-server"
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

dependency "k8s" {
   config_path = "../k8s/aks-cluster"
}

dependency "resource_group" {
  config_path = "../resource-group"
}

inputs = {
  resource_group_name                      = dependency.resource_group.outputs.name
  resource_group_location                  = dependency.resource_group.outputs.location
}

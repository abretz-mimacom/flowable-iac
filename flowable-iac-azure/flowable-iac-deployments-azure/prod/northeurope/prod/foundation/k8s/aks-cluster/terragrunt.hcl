# Include the root terragrunt `root.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include {
  path = find_in_parent_folders("root.hcl")
}

# We override the terraform block source attribute here just for the QA environment to show how you would deploy a
# different version of the module in a specific environment.
terraform {
  source = "../../../../../../../flowable-iac-modules-azure/k8s/aks-cluster"
}

locals {
  # Automatically load environment-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract out common variables for reuse
  workload = local.account_vars.locals.workload
}

dependency "resource_group" {
  config_path = "../../resource-group"
}

inputs = {
  location                                 = dependency.resource_group.outputs.location
  resource_group_name                      = dependency.resource_group.outputs.name
  kubeconfig_filename_path                 = "${get_terragrunt_dir()}"
}
  
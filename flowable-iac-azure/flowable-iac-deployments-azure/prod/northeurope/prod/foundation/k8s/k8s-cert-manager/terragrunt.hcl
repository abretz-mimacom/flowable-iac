# Include the root terragrunt `root.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include {
  path = find_in_parent_folders("root.hcl")
}

# We reference the source of the module to be used in this environment
terraform {
  source = "../../../../../../../flowable-iac-modules-azure/k8s/k8s-cert-manager"
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}


dependency "k8s" {
  config_path = "../aks-cluster"
}

inputs = {
  name                                  = "cert-manager"
  namespace                             = "cert-manager"
  cluster_name                          = dependency.k8s.outputs.cluster_name
  cluster_resource_group_name           = dependency.k8s.outputs.cluster_resource_group_name
  values                                = file("values.yaml")
}


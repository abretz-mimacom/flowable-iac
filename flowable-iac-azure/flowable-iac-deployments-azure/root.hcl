# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {

  # merge all configuration properties into a single map
  # mind! properties can be overwritten
  common_vars = merge(
    read_terragrunt_config(find_in_parent_folders("account.hcl", "non_existing.hcl"), {locals = {}}).locals,
    read_terragrunt_config(find_in_parent_folders("region.hcl", "non_existing.hcl"), {locals = {}}).locals,
    read_terragrunt_config(find_in_parent_folders("env.hcl", "non_existing.hcl"), {locals = {}}).locals,
    read_terragrunt_config(find_in_parent_folders("foundation.hcl", "non_existing.hcl"), {locals = {}}).locals,
    read_terragrunt_config(find_in_parent_folders("app.hcl", "non_existing.hcl"), {locals = {}}).locals
  )
}

# Generate an Azure provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features {}
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an azure storage container
remote_state {
  backend = "azurerm"
  config = {
    resource_group_name  = local.common_vars.state_storage_resource_group_name
    storage_account_name = local.common_vars.state_storage_account_name
    container_name       = local.common_vars.state_storage_container_name
    key                  = "${path_relative_to_include()}/terraform.tfstate"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.common_vars
)
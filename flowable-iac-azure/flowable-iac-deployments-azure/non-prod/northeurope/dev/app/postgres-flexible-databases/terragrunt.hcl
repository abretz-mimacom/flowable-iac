# Include the root terragrunt `root.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include {
  path = find_in_parent_folders("root.hcl")
}

# We reference the source of the module to be used in this environment
terraform {
  source = "../../../../../../flowable-iac-modules-azure/postgresql-managed-flexible-database"
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  app_vars         = read_terragrunt_config(find_in_parent_folders("app.hcl"))
}

dependency "postgres_server" {
  config_path = "../../foundation/postgres-flexible-server"
}

inputs = {
  databases = {
    flw_work_db = {
      db_server_id = dependency.postgres_server.outputs.db_server_id
    },
    flw_design_db = {
      db_server_id = dependency.postgres_server.outputs.db_server_id
    },
  }
}
  
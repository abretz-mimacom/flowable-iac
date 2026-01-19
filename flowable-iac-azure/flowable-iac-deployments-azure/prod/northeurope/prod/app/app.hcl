# Set common variables for the app. This is automatically pulled in in the root terragrunt root.hcl configuration to
# feed forward to the child modules.
locals {
  # enable Flowable components
  flowable_control_enabled = true
  flowable_design_enabled  = false
  flowable_work_enabled    = true
  flowable_engage_enabled  = false

  # General Elasticsearch settings
  es_enabled                = true
}

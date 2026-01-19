# Set common variables for the environment. This is automatically pulled in in the root terragrunt root.hcl configuration to
# feed forward to the child modules.
locals {
  environment = "qa"
}
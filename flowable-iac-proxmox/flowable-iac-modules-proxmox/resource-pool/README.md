# Proxmox - Resource Pool

This is a Terraform module for creating a resource pool on Proxmox Virtual Environment.

## Overview

Resource pools in Proxmox help organize and manage VMs and containers. They are the equivalent of Azure Resource Groups.

## Usage

```hcl
module "resource_pool" {
  source = "../modules/resource-pool"

  name       = "flowable-iac"
  env_suffix = "prod"
  comment    = "Flowable production environment"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Name of the resource pool | string | - | yes |
| env_suffix | Environment suffix (e.g., dev, prod) | string | - | yes |
| comment | Comment for the resource pool | string | "" | no |

## Outputs

| Name | Description |
|------|-------------|
| pool_id | The ID of the resource pool |
| name | The name of the resource pool |

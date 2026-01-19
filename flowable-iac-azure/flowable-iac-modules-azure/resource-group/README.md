<!-- BEGIN_TF_DOCS -->
# Azure - Resource Group

This a Terraform module for creating a resource group on Azure.
See the documentation below for additional info on using this module.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | >=1.2.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.81 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurecaf"></a> [azurecaf](#provider\_azurecaf) | >=1.2.6 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 2.81 |

## Resources

| Name | Type |
|------|------|
| [azurecaf_name.rg_name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Location of the resource group | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Basename of the resource group | `string` | n/a | yes |
| <a name="input_env_suffix"></a> [env\_suffix](#input\_env\_suffix) | Environment suffix of the resource group | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | The fullname of the created resource group |
| <a name="output_location"></a> [location](#output\_location) | The location of the created resource group |
| <a name="output_id"></a> [id](#output\_id) | The ID of the created resource group |
<!-- END_TF_DOCS -->
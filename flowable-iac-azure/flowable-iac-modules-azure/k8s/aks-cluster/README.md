<!-- BEGIN_TF_DOCS -->
# Azure - K8s - AKS Cluster

This a Terraform module for a Kubernetes Cluster on Azure Kubernetes Service (AKS).
See the documentation below for additional info on using this module.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | >=1.2.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.81 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 2.81 |
| <a name="provider_azurecaf"></a> [azurecaf](#provider\_azurecaf) | >=1.2.6 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |

## Resources

| Name | Type |
|------|------|
| [azurecaf_name.aks_name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurerm_kubernetes_cluster.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [local_file.kubeconfig](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [azurerm_kubernetes_cluster.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Location of the AKS cluster | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Base name of the AKS cluster | `string` | n/a | yes |
| <a name="input_env_suffix"></a> [env\_suffix](#input\_env\_suffix) | Environment suffix of the AKS cluster | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group where the cluster will be created | `string` | n/a | yes |
| <a name="input_default_node_pool_name"></a> [default\_node\_pool\_name](#input\_default\_node\_pool\_name) | Name of the default node pool | `string` | n/a | yes |
| <a name="input_default_node_pool_node_count"></a> [default\_node\_pool\_node\_count](#input\_default\_node\_pool\_node\_count) | Number of nodes in this node pool (when auto scaling is enabled this is will be the initial node pool size) | `number` | n/a | yes |
| <a name="input_default_node_pool_vm_size"></a> [default\_node\_pool\_vm\_size](#input\_default\_node\_pool\_vm\_size) | Logical descriptor of the Virtual Machine size. See https://docs.microsoft.com/nl-nl/azure/virtual-machines/sizes for more info. | `string` | n/a | yes |
| <a name="input_default_node_pool_os_disk_size_gb"></a> [default\_node\_pool\_os\_disk\_size\_gb](#input\_default\_node\_pool\_os\_disk\_size\_gb) | Size of the OS disk in GB | `number` | n/a | yes |
| <a name="input_default_node_pool_enable_auto_scaling"></a> [default\_node\_pool\_enable\_auto\_scaling](#input\_default\_node\_pool\_enable\_auto\_scaling) | Enable auto scaling for this node pool | `bool` | `false` | no |
| <a name="input_default_node_pool_auto_scaling_min_count"></a> [default\_node\_pool\_auto\_scaling\_min\_count](#input\_default\_node\_pool\_auto\_scaling\_min\_count) | The maximum number of nodes for this node pool when auto scaling is enabled | `number` | `""` | no |
| <a name="input_default_node_pool_auto_scaling_max_count"></a> [default\_node\_pool\_auto\_scaling\_max\_count](#input\_default\_node\_pool\_auto\_scaling\_max\_count) | The minimum number of nodes for this node pool when auto scaling is enabled | `number` | `""` | no |
| <a name="input_kubeconfig_filename_path"></a> [kubeconfig\_filename\_path](#input\_kubeconfig\_filename\_path) | The path where the kubeconfig file will be placed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the cluster |
| <a name="output_cluster_resource_group_name"></a> [cluster\_resource\_group\_name](#output\_cluster\_resource\_group\_name) | Name of the resource group where the cluster is located |
| <a name="output_cluster_kubeconfig"></a> [cluster\_kubeconfig](#output\_cluster\_kubeconfig) | The kubeconfig that can be used to connect to the cluster |
<!-- END_TF_DOCS -->
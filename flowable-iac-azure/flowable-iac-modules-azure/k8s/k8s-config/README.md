<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.81 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 2.81 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.5.1 |

## Resources

| Name | Type |
|------|------|
| [kubernetes_namespace.flowable](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.flowable_docker_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.flowable_license](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [azurerm_key_vault.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.flowable_license](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.flowable_repo_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.flowable_repo_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_kubernetes_cluster.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Name of the namespace where the resources will reside | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Then name of kubernetes cluster | `string` | n/a | yes |
| <a name="input_cluster_resource_group_name"></a> [cluster\_resource\_group\_name](#input\_cluster\_resource\_group\_name) | Then name of cluster resource group name | `string` | n/a | yes |
| <a name="input_flowable_docker_registry_server"></a> [flowable\_docker\_registry\_server](#input\_flowable\_docker\_registry\_server) | The Flowable docker registry server | `string` | `"artifacts.flowable.com"` | no |
| <a name="input_flowable_repo_username"></a> [flowable\_repo\_username](#input\_flowable\_repo\_username) | The Flowable docker registry username which can be used to override `keyvault_secret_name_flowable_repo_username` | `string` | `""` | no |
| <a name="input_flowable_repo_password"></a> [flowable\_repo\_password](#input\_flowable\_repo\_password) | The Flowable docker registry password which can be used to override `keyvault_secret_name_flowable_repo_password` | `string` | `""` | no |
| <a name="input_secret_name_docker_auth"></a> [secret\_name\_docker\_auth](#input\_secret\_name\_docker\_auth) | Name of the Kubernetes secret which holds the Docker registry authentication | `string` | n/a | yes |
| <a name="input_secret_name_flowable_license"></a> [secret\_name\_flowable\_license](#input\_secret\_name\_flowable\_license) | Name of the Kubernetes secret that will be created to store the Flowable license | `string` | n/a | yes |
| <a name="input_keyvault_name"></a> [keyvault\_name](#input\_keyvault\_name) | Name of the Azure keyvault that will be used to fetch the authentication related credentials and settings | `string` | n/a | yes |
| <a name="input_keyvault_resource_group_name"></a> [keyvault\_resource\_group\_name](#input\_keyvault\_resource\_group\_name) | Name of the resource group in which the Azure keyvault resides | `string` | n/a | yes |
| <a name="input_keyvault_secret_name_flowable_repo_username"></a> [keyvault\_secret\_name\_flowable\_repo\_username](#input\_keyvault\_secret\_name\_flowable\_repo\_username) | Name of the Azure keyvault secret which holds the Flowable repository username | `string` | n/a | yes |
| <a name="input_keyvault_secret_name_flowable_repo_password"></a> [keyvault\_secret\_name\_flowable\_repo\_password](#input\_keyvault\_secret\_name\_flowable\_repo\_password) | Name of the Azure keyvault secret which holds the Flowable repository password | `string` | n/a | yes |
| <a name="input_keyvault_secret_name_flowable_license"></a> [keyvault\_secret\_name\_flowable\_license](#input\_keyvault\_secret\_name\_flowable\_license) | Name of the Azure keyvault secret which holds the Flowable license | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
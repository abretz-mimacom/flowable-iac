<!-- BEGIN_TF_DOCS -->
# Azure - Flowable App

This a Terraform module for deploying Flowable services using the [Flowable Helm Chart](https://code.flowable.com/flw-lic/flowable-product/flowable-iac/flowable-iac-helm)
on Azure Kubernetes Service (AKS).
See the documentation below for additional info on using this module.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.97 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.4.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 2.97 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.8.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.4.1 |

## Resources

| Name | Type |
|------|------|
| [helm_release.flowable](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_secret.flowable_db_creds](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [azurerm_key_vault.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.flowable_db_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.flowable_db_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.flowable_repo_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.flowable_repo_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_kubernetes_cluster.credentials](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the Kubernetes cluster | `string` | n/a | yes |
| <a name="input_cluster_resource_group_name"></a> [cluster\_resource\_group\_name](#input\_cluster\_resource\_group\_name) | Name of the Kubernetes cluster resouce group | `string` | n/a | yes |
| <a name="input_keyvault_name"></a> [keyvault\_name](#input\_keyvault\_name) | Name of the keyvault that holds the repo credentials secrets | `string` | n/a | yes |
| <a name="input_keyvault_resource_group_name"></a> [keyvault\_resource\_group\_name](#input\_keyvault\_resource\_group\_name) | Name of the resource group where the keyvault resides | `string` | n/a | yes |
| <a name="input_keyvault_secret_name_flowable_repo_username"></a> [keyvault\_secret\_name\_flowable\_repo\_username](#input\_keyvault\_secret\_name\_flowable\_repo\_username) | Name of the keyvault secret that holds the repo username | `string` | n/a | yes |
| <a name="input_keyvault_secret_name_flowable_repo_password"></a> [keyvault\_secret\_name\_flowable\_repo\_password](#input\_keyvault\_secret\_name\_flowable\_repo\_password) | Name of the keyvault secret that holds the repo password | `string` | n/a | yes |
| <a name="input_keyvault_secret_name_flowable_db_username"></a> [keyvault\_secret\_name\_flowable\_db\_username](#input\_keyvault\_secret\_name\_flowable\_db\_username) | Name of the Azure keyvault secret which holds the Flowable db username | `string` | n/a | yes |
| <a name="input_keyvault_secret_name_flowable_db_password"></a> [keyvault\_secret\_name\_flowable\_db\_password](#input\_keyvault\_secret\_name\_flowable\_db\_password) | Name of the Azure keyvault secret which holds the Flowable db password | `string` | n/a | yes |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | Name of the Helm release | `string` | n/a | yes |
| <a name="input_release_namespace"></a> [release\_namespace](#input\_release\_namespace) | Namespace of the  Helm release | `string` | n/a | yes |
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | Name of the Flowable Helm chart | `string` | n/a | yes |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Version of the Flowable Helm chart | `string` | n/a | yes |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Create release namespace | `string` | `"true"` | no |
| <a name="input_helm_repo_url"></a> [helm\_repo\_url](#input\_helm\_repo\_url) | Flowable Helm repository url | `string` | `"https://artifacts.flowable.com/flowable-helm"` | no |
| <a name="input_db_username_suffix"></a> [db\_username\_suffix](#input\_db\_username\_suffix) | Database username suffix (f.e. when hostname is required) | `string` | `""` | no |
| <a name="input_values"></a> [values](#input\_values) | The Flowalbe Helm chart values in (yaml format). See https://code.flowable.com/flw-lic/flowable-product/flowable-iac/flowable-iac-helm for more information | `string` | n/a | yes |
| <a name="input_format_db_username"></a> [format\_db\_username](#input\_format\_db\_username) | Format the db username to comply to Azure naming format | `bool` | `true` | no |
| <a name="input_db_server_name"></a> [db\_server\_name](#input\_db\_server\_name) | Name of the Flowable DB server | `string` | `"flowable-db-server"` | no |
| <a name="input_flowable_db_username"></a> [flowable\_db\_username](#input\_flowable\_db\_username) | The Flowable db username which can be used to override `keyvault_secret_name_flowable_db_username` | `string` | `""` | no |
| <a name="input_flowable_db_password"></a> [flowable\_db\_password](#input\_flowable\_db\_password) | The Flowable db password which can be used to override `keyvault_secret_name_flowable_db_password` | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Name of the namespace where the resources will reside | `string` | n/a | yes |
| <a name="input_atomic"></a> [atomic](#input\_atomic) | If set, installation process purges chart on fail. The wait flag will be set automatically if atomic is used. | `bool` | `false` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Time in seconds to wait for any individual kubernetes operation. Defaults to 900 seconds. | `string` | `900` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
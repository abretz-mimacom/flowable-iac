<!-- BEGIN_TF_DOCS -->
# Azure - K8s - ArgoCD configuration

This is a Terraform module for deploying the [ArgoCD configuration](https://github.com/argoproj/argo-cd) on Azure Kubernetes Service (AKS).

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.97 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.4.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.14.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 2.97 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.14.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_manifest.cert_manager_cluster_issuer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [azurerm_kubernetes_cluster.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acme_email"></a> [acme\_email](#input\_acme\_email) | The name of the ArgoCD helm chart values file to use | `string` | `"flwdevops@flowable.com"` | no |
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | Default Admin Password | `string` | `""` | no |
| <a name="input_argocd_chart_version"></a> [argocd\_chart\_version](#input\_argocd\_chart\_version) | Version of ArgoCD chart to install | `string` | `"4.9.16"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Then name of kubernetes cluster | `string` | n/a | yes |
| <a name="input_cluster_resource_group_name"></a> [cluster\_resource\_group\_name](#input\_cluster\_resource\_group\_name) | Then name of cluster resource group name | `string` | n/a | yes |
| <a name="input_enable_dex"></a> [enable\_dex](#input\_enable\_dex) | Enabled the dex server? | `bool` | `true` | no |
| <a name="input_ingress_type"></a> [ingress\_type](#input\_ingress\_type) | The default ingress class used for the ingress objects of this module | `string` | `"nginx"` | no |
| <a name="input_insecure"></a> [insecure](#input\_insecure) | Disable TLS on the ArgoCD API Server? (adds the --insecure flag to the argocd-server command) | `bool` | `false` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace to install ArgoCD chart into | `string` | `"argocd"` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | Helm release name | `string` | `"argocd"` | no |
| <a name="input_timeout_seconds"></a> [timeout\_seconds](#input\_timeout\_seconds) | Helm chart deployment can sometimes take longer than the default 5 minutes. Set a custom timeout here. | `number` | `800` | no |
| <a name="input_values_file"></a> [values\_file](#input\_values\_file) | The name of the ArgoCD helm chart values file to use | `string` | `"values.yaml"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
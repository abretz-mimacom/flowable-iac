<!-- BEGIN_TF_DOCS -->
# Azure - K8s - Prometheus

This is a Terraform module for deploying the [kube-prometheus stack](https://github.com/prometheus-operator/kube-prometheus) on Azure Kubernetes Service (AKS).
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
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.monitoring](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [azurerm_kubernetes_cluster.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Then name of kubernetes cluster | `string` | n/a | yes |
| <a name="input_cluster_resource_group_name"></a> [cluster\_resource\_group\_name](#input\_cluster\_resource\_group\_name) | Then name of cluster resource group name | `string` | n/a | yes |
| <a name="input_values"></a> [values](#input\_values) | The Helm chart values in (yaml format). See https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml for more information | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
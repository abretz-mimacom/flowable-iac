/**
  * # Azure - K8s - ArgoCD configuration
  * 
  * This is a Terraform module for deploying the [ArgoCD configuration](https://github.com/argoproj/argo-cd) on Azure Kubernetes Service (AKS).
  *
  */

data "azurerm_kubernetes_cluster" "default" {
  name                = var.cluster_name
  resource_group_name = var.cluster_resource_group_name
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.default.kube_admin_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.default.kube_admin_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.default.kube_admin_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.default.kube_admin_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.default.kube_admin_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.default.kube_admin_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.default.kube_admin_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.default.kube_admin_config.0.cluster_ca_certificate)
  }
}

resource "kubernetes_manifest" "cert_manager_cluster_issuer" {
  manifest = yamldecode(templatefile("${path.root}/clusterissuer.tpl.yaml",
    {
      ingress_type = var.ingress_type
      acme_email   = var.acme_email
  }))
}

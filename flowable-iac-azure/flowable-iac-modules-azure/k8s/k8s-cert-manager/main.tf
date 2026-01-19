/**
  * # Azure - K8s - Cert-Manager
  * 
  * This is a Terraform module for deploying the [Cert Manager](https://github.com/cert-manager/cert-manager) on Azure Kubernetes Service (AKS).
  * See the documentation below for additional info on using this module.
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

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "cert_manager" {
  depends_on = [kubernetes_namespace.cert_manager]
  name       = var.release_name

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  version   = var.chart_version
  namespace = var.namespace

  atomic = true

  values = [
    "${var.values}"
  ]
}

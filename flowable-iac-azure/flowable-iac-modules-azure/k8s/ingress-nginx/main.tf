/**
  * # Azure - K8s - Ingress Nginx
  * 
  * This is a Terraform module for deploying the [Ingress Nginx Controller](https://kubernetes.github.io/ingress-nginx/) on Azure Kubernetes Service (AKS).
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

resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress"
  }
}

resource "helm_release" "nginx_ingress" {
  depends_on = [kubernetes_namespace.ingress]
  name       = "nginx-ingress"

  repository = "https://kubernetes.github.io/ingress-nginx"
  version    = "4.2.5"
  chart      = "ingress-nginx"

  atomic       = true
  force_update = true

  verify = false

  namespace = "ingress"
  
  create_namespace = false

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
    value = "/healthz"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-dns-label-name"
    value = var.azure_dns_label
  }

  values = [
    "${var.values}"
  ]
}

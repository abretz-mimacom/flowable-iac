/**
  * # Proxmox - Flowable App
  * 
  * Deploys Flowable application on K3s cluster using Helm.
  */

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

resource "helm_release" "flowable" {
  name             = var.release_name
  repository       = "https://artifacts.flowable.com/repository/helm/"
  chart            = var.chart_name
  version          = var.chart_version
  namespace        = var.release_namespace
  create_namespace = true

  values = var.values != "" ? [var.values] : []

  timeout = 600
}

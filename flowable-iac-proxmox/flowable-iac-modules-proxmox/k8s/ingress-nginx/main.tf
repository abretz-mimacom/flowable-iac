/**
  * # Proxmox - Ingress NGINX
  * 
  * Deploys NGINX Ingress Controller on K3s cluster.
  */

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

resource "helm_release" "ingress_nginx" {
  name             = var.release_name
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = var.chart_version
  namespace        = var.release_namespace
  create_namespace = true

  values = [
    yamlencode({
      controller = {
        service = {
          type = "LoadBalancer"
        }
      }
    })
  ]
}

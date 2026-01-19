data "azurerm_kubernetes_cluster" "cluster" {
  name                = var.cluster_name
  resource_group_name = var.cluster_resource_group_name
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.cluster.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.cluster.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)
  }
}

# Create namespace for ELK stack
resource "kubernetes_namespace" "elk" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.release_namespace
  }
}

# Deploy Elasticsearch using Helm
resource "helm_release" "elasticsearch" {
  name       = var.elasticsearch_release_name
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  version    = var.elasticsearch_chart_version
  namespace  = var.release_namespace

  depends_on = [kubernetes_namespace.elk]

  values = [
    yamlencode({
      replicas = var.elasticsearch_replicas

      # Minimize resource usage
      esJavaOpts = "-Xmx2g -Xms2g"

      resources = {
        requests = {
          cpu    = var.elasticsearch_resources_requests_cpu
          memory = var.elasticsearch_resources_requests_memory
        }
        limits = {
          cpu    = var.elasticsearch_resources_limits_cpu
          memory = var.elasticsearch_resources_limits_memory
        }
      }

      volumeClaimTemplate = {
        storageClassName = var.elasticsearch_storage_class
        resources = {
          requests = {
            storage = var.elasticsearch_storage_size
          }
        }
      }

      # Security configuration
      protocol = "http"
      
      # Enable sysctl init container for production readiness
      sysctlInitContainer = {
        enabled = true
      }
    })
  ]

  timeout = 600
}

# Deploy Kibana using Helm
resource "helm_release" "kibana" {
  name       = var.kibana_release_name
  repository = "https://helm.elastic.co"
  chart      = "kibana"
  version    = var.kibana_chart_version
  namespace  = var.release_namespace

  depends_on = [helm_release.elasticsearch]

  values = [
    yamlencode({
      replicas = var.kibana_replicas

      elasticsearchHosts = "http://${var.elasticsearch_release_name}-master:9200"

      service = {
        type = "ClusterIP"
      }

      resources = {
        requests = {
          cpu    = "500m"
          memory = "1Gi"
        }
        limits = {
          cpu    = "1000m"
          memory = "2Gi"
        }
      }
    })
  ]

  timeout = 600
}

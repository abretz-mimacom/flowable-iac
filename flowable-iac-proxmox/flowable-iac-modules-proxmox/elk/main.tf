/**
  * # Proxmox - ELK Stack
  * 
  * This is a Terraform module for deploying Elasticsearch and Kibana on K3s cluster.
  * Uses official Elastic Helm charts.
  */

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
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

      # Configure Java heap size - should be approximately half of memory limit
      esJavaOpts = "-Xmx${var.elasticsearch_heap_size} -Xms${var.elasticsearch_heap_size}"

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
          cpu    = var.kibana_resources_requests_cpu
          memory = var.kibana_resources_requests_memory
        }
        limits = {
          cpu    = var.kibana_resources_limits_cpu
          memory = var.kibana_resources_limits_memory
        }
      }
    })
  ]

  timeout = 600
}

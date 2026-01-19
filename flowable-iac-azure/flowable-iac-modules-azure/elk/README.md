# ELK Stack Terraform Module for Azure Kubernetes

This Terraform module provisions the ELK (Elasticsearch, Logstash, Kibana) stack on Azure Kubernetes Service (AKS) using official Elastic Helm charts.

## Overview

This module deploys:
- **Elasticsearch**: A distributed search and analytics engine
- **Kibana**: A visualization and management tool for Elasticsearch

The module uses official Elastic Helm charts instead of Bitnami images, providing better integration and support for production workloads.

## Features

- Official Elastic Helm charts for Elasticsearch and Kibana
- Configurable resource limits and requests
- Persistent storage with configurable storage class and size
- Configurable number of replicas for high availability
- Production-ready sysctl init container for Elasticsearch
- Isolated namespace deployment

## Usage

```hcl
module "elk" {
  source = "../../path/to/elk-module"

  cluster_name                = "my-aks-cluster"
  cluster_resource_group_name = "my-resource-group"
  release_namespace           = "elastic-system"
  
  # Elasticsearch configuration
  elasticsearch_replicas      = 3
  elasticsearch_storage_size  = "50Gi"
  elasticsearch_storage_class = "managed-premium"
  
  # Kibana configuration
  kibana_replicas = 2
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| cluster_name | The name of the AKS cluster | string | - | yes |
| cluster_resource_group_name | The resource group name of the AKS cluster | string | - | yes |
| release_namespace | Kubernetes namespace for ELK stack | string | "elastic-system" | no |
| elasticsearch_replicas | Number of Elasticsearch replicas | number | 2 | no |
| elasticsearch_storage_class | Storage class for Elasticsearch PVs | string | "default" | no |
| elasticsearch_storage_size | Size of PV for each Elasticsearch node | string | "30Gi" | no |
| elasticsearch_resources_requests_cpu | CPU request for Elasticsearch pods | string | "1000m" | no |
| elasticsearch_resources_requests_memory | Memory request for Elasticsearch pods | string | "2Gi" | no |
| elasticsearch_resources_limits_cpu | CPU limit for Elasticsearch pods | string | "2000m" | no |
| elasticsearch_resources_limits_memory | Memory limit for Elasticsearch pods | string | "4Gi" | no |
| kibana_replicas | Number of Kibana replicas | number | 1 | no |

## Outputs

| Name | Description |
|------|-------------|
| elasticsearch_service_name | Elasticsearch service name |
| elasticsearch_service_port | Elasticsearch service port (9200) |
| elasticsearch_endpoint | Full Elasticsearch internal endpoint URL |
| kibana_service_name | Kibana service name |
| kibana_service_port | Kibana service port (5601) |
| namespace | Namespace where ELK stack is deployed |

## Integration with Flowable

When `es_enabled` is set to `true` in the Flowable app configuration, the application will automatically connect to the external Elasticsearch instance deployed by this module.

The Flowable Helm chart configuration is updated to:
1. Disable the embedded Elasticsearch (`elasticsearch.enabled: false`)
2. Configure Flowable to use the external Elasticsearch endpoint

## Requirements

- Terraform >= 1.0
- Azure provider >= 3.0
- Helm provider >= 2.0
- Kubernetes provider >= 2.0

## Notes

- Elasticsearch uses the official Elastic Helm charts (https://helm.elastic.co)
- The module creates persistent volume claims for Elasticsearch data
- Production deployments should use at least 3 Elasticsearch replicas for high availability
- Kibana is configured to automatically connect to the deployed Elasticsearch cluster

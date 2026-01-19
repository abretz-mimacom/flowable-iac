variable "kubeconfig_path" {
  description = "Path to kubeconfig file for K3s cluster"
  type        = string
}

variable "release_namespace" {
  description = "Kubernetes namespace where ELK stack will be deployed"
  type        = string
  default     = "elastic-system"
}

variable "elasticsearch_release_name" {
  description = "Helm release name for Elasticsearch"
  type        = string
  default     = "elasticsearch"
}

variable "kibana_release_name" {
  description = "Helm release name for Kibana"
  type        = string
  default     = "kibana"
}

variable "elasticsearch_replicas" {
  description = "Number of Elasticsearch replicas"
  type        = number
  default     = 2
}

variable "elasticsearch_storage_class" {
  description = "Storage class for Elasticsearch persistent volumes"
  type        = string
  default     = "default"
}

variable "elasticsearch_storage_size" {
  description = "Size of persistent volume for each Elasticsearch node"
  type        = string
  default     = "30Gi"
}

variable "elasticsearch_resources_requests_cpu" {
  description = "CPU request for Elasticsearch pods"
  type        = string
  default     = "1000m"
}

variable "elasticsearch_resources_requests_memory" {
  description = "Memory request for Elasticsearch pods"
  type        = string
  default     = "2Gi"
}

variable "elasticsearch_resources_limits_cpu" {
  description = "CPU limit for Elasticsearch pods"
  type        = string
  default     = "2000m"
}

variable "elasticsearch_resources_limits_memory" {
  description = "Memory limit for Elasticsearch pods"
  type        = string
  default     = "4Gi"
}

variable "elasticsearch_chart_version" {
  description = "Version of the Elasticsearch Helm chart"
  type        = string
  default     = "7.17.3"
}

variable "elasticsearch_heap_size" {
  description = "Elasticsearch Java heap size (e.g., '2g'). Should be approximately half of memory limit."
  type        = string
  default     = "2g"
}

variable "kibana_replicas" {
  description = "Number of Kibana replicas"
  type        = number
  default     = 1
}

variable "kibana_resources_requests_cpu" {
  description = "CPU request for Kibana pods"
  type        = string
  default     = "500m"
}

variable "kibana_resources_requests_memory" {
  description = "Memory request for Kibana pods"
  type        = string
  default     = "1Gi"
}

variable "kibana_resources_limits_cpu" {
  description = "CPU limit for Kibana pods"
  type        = string
  default     = "1000m"
}

variable "kibana_resources_limits_memory" {
  description = "Memory limit for Kibana pods"
  type        = string
  default     = "2Gi"
}

variable "kibana_chart_version" {
  description = "Version of the Kibana Helm chart"
  type        = string
  default     = "7.17.3"
}

variable "create_namespace" {
  description = "Whether to create the namespace"
  type        = bool
  default     = true
}

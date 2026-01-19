variable "kubeconfig_path" {
  description = "Path to kubeconfig file"
  type        = string
}

variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "ingress-nginx"
}

variable "release_namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "ingress-nginx"
}

variable "chart_version" {
  description = "Helm chart version"
  type        = string
  default     = "4.7.1"
}

variable "kubeconfig_path" {
  description = "Path to kubeconfig file for K3s cluster"
  type        = string
}

variable "release_name" {
  description = "Name of the Helm release"
  type        = string
}

variable "release_namespace" {
  description = "Kubernetes namespace to install into"
  type        = string
}

variable "chart_name" {
  description = "Name of the Helm chart"
  type        = string
  default     = "flowable"
}

variable "chart_version" {
  description = "Version of the Helm chart"
  type        = string
  default     = "3.14.4-beta.2"
}

variable "values" {
  description = "Values file content for Helm chart"
  type        = string
  default     = ""
}

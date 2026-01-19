variable "cluster_name" {
  description = "Then name of kubernetes cluster"
  type        = string
}

variable "cluster_resource_group_name" {
  description = "Then name of cluster resource group name"
  type        = string
}

# cert manager variables
variable "release_name" {
  type        = string
  description = "Helm release name"
  default     = "cert-manager"
}

variable "namespace" {
  description = "Namespace to install chart into"
  type        = string
  default     = "cert-manager"
}

variable "chart_version" {
  description = "Version of the chart to install"
  type        = string
  default     = "1.13.1"
}

variable "values" {
  description = "The Helm chart values in (yaml format). See https://github.com/bitnami/charts/blob/master/bitnami/nginx-ingress-controller/values.yaml for more information"
  type        = string
  default     = ""
}

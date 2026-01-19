variable cluster_name {
    description = "Then name of kubernetes cluster"
    type = string
}

variable cluster_resource_group_name {
    description = "Then name of cluster resource group name"
    type = string
}

variable "values" {
  description = "The Helm chart values in (yaml format). See https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml for more information"
  type        = string
  default     = ""
}

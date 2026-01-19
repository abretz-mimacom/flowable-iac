variable cluster_name {
    description = "Then name of kubernetes cluster"
    type = string
}

variable cluster_resource_group_name {
    description = "Then name of cluster resource group name"
    type = string
}

variable azure_dns_label {
    description = "The dns label that will be configured (<label>.<region>.westeurope.cloudapp.azure.com)"
    type = string
}

variable "values" {
  description = "The Helm chart values in (yaml format). See https://github.com/bitnami/charts/blob/master/bitnami/nginx-ingress-controller/values.yaml for more information"
  type        = string
  default     = ""
}

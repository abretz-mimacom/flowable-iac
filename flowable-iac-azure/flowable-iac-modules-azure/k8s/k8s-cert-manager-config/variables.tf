# k8s related vars
variable "cluster_name" {
  description = "Then name of kubernetes cluster"
  type        = string
}

variable "cluster_resource_group_name" {
  description = "Then name of cluster resource group name"
  type        = string
}

# ArgoCD variables
variable "release_name" {
  type        = string
  description = "Helm release name"
  default     = "argocd"
}
variable "namespace" {
  description = "Namespace to install ArgoCD chart into"
  type        = string
  default     = "argocd"
}

variable "argocd_chart_version" {
  description = "Version of ArgoCD chart to install"
  type        = string
  default     = "4.9.16" # See https://artifacthub.io/packages/helm/argo/argo-cd for latest version(s)
}

# Helm chart deployment can sometimes take longer than the default 5 minutes
variable "timeout_seconds" {
  type        = number
  description = "Helm chart deployment can sometimes take longer than the default 5 minutes. Set a custom timeout here."
  default     = 800 # 10 minutes
}

variable "admin_password" {
  description = "Default Admin Password"
  type        = string
  default     = ""
}

variable "values_file" {
  description = "The name of the ArgoCD helm chart values file to use"
  type        = string
  default     = "values.yaml"
}

variable "acme_email" {
  description = "The name of the ArgoCD helm chart values file to use"
  type        = string
  default     = "flwdevops@flowable.com"
}

variable "ingress_type" {
  description = "The default ingress class used for the ingress objects of this module"
  type        = string
  default     = "nginx"
}

variable "enable_dex" {
  type        = bool
  description = "Enabled the dex server?"
  default     = true
}

variable "insecure" {
  type        = bool
  description = "Disable TLS on the ArgoCD API Server? (adds the --insecure flag to the argocd-server command)"
  default     = false
}
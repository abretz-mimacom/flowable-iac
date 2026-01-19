variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "cluster_resource_group_name" {
  description = "Name of the Kubernetes cluster resouce group"
  type        = string
}

variable "keyvault_name" {
  description = "Name of the keyvault that holds the repo credentials secrets"
  type        = string
}

variable "keyvault_resource_group_name" {
  description = "Name of the resource group where the keyvault resides"
  type        = string
}

variable "keyvault_secret_name_flowable_repo_username" {
  description = "Name of the keyvault secret that holds the repo username"
  type        = string
}

variable "keyvault_secret_name_flowable_repo_password" {
  description = "Name of the keyvault secret that holds the repo password"
  type        = string
}

variable "keyvault_secret_name_flowable_db_username" {
  description = "Name of the Azure keyvault secret which holds the Flowable db username"
  type        = string
}

variable "keyvault_secret_name_flowable_db_password" {
  description = "Name of the Azure keyvault secret which holds the Flowable db password"
  type        = string
}

variable "release_name" {
  description = "Name of the Helm release"
  type        = string
}

variable "release_namespace" {
  description = "Namespace of the  Helm release"
  type        = string
}

variable "chart_name" {
  description = "Name of the Flowable Helm chart"
  type        = string
}

variable "chart_version" {
  description = "Version of the Flowable Helm chart"
  type        = string
}

variable "create_namespace" {
  description = "Create release namespace"
  default     = "true"
  type        = string
}

variable "helm_repo_url" {
  description = "Flowable Helm repository url"
  default     = "https://artifacts.flowable.com/flowable-helm"
  type        = string
}

variable "db_username_suffix" {
  description = "Database username suffix (f.e. when hostname is required)"
  default     = ""
  type        = string
}

variable "values" {
  description = "The Flowalbe Helm chart values in (yaml format). See https://code.flowable.com/flw-lic/flowable-product/flowable-iac/flowable-iac-helm for more information"
  type        = string
}

variable "format_db_username" {
  description = "Format the db username to comply to Azure naming format"
  type        = bool
  default     = true
}

variable "db_server_name" {
  description = "Name of the Flowable DB server"
  type        = string
  default     = "flowable-db-server"
}

variable "flowable_db_username" {
  description = "The Flowable db username which can be used to override `keyvault_secret_name_flowable_db_username`"
  default     = ""
  type        = string
}

variable "flowable_db_password" {
  description = "The Flowable db password which can be used to override `keyvault_secret_name_flowable_db_password`"
  default     = ""
  sensitive   = true
  type        = string
}

variable "namespace" {
  description = "Name of the namespace where the resources will reside"
  type        = string
}

variable "atomic" {
  description = "If set, installation process purges chart on fail. The wait flag will be set automatically if atomic is used."
  default     = false
  type        = bool
}

variable "timeout" {
  description = " Time in seconds to wait for any individual kubernetes operation. Defaults to 900 seconds."
  default     = 900
  type        = string
}


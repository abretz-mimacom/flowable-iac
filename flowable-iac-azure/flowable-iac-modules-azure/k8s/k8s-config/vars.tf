variable "namespace" {
  description = "Name of the namespace where the resources will reside"
  type = string
}

variable "cluster_name" {
  description = "Then name of kubernetes cluster"
  type = string
}

variable "cluster_resource_group_name" {
  description = "Then name of cluster resource group name"
  type = string
}

variable "flowable_docker_registry_server" {
  description = "The Flowable docker registry server"
  default     = "artifacts.flowable.com"
  type = string
}

variable "flowable_repo_username" {
  description = "The Flowable docker registry username which can be used to override `keyvault_secret_name_flowable_repo_username`"
  default = ""
  type = string
}

variable "flowable_repo_password" {
  description = "The Flowable docker registry password which can be used to override `keyvault_secret_name_flowable_repo_password`"
  default = ""
  sensitive   = true
  type = string
}

variable "secret_name_docker_auth" {
  description = "Name of the Kubernetes secret which holds the Docker registry authentication"
  type = string
}

variable "secret_name_flowable_license" {
  description = "Name of the Kubernetes secret that will be created to store the Flowable license"
  type = string
}

variable "keyvault_name" {
  description = "Name of the Azure keyvault that will be used to fetch the authentication related credentials and settings"
  type = string
}

variable "keyvault_resource_group_name" {
  description = "Name of the resource group in which the Azure keyvault resides"
  type = string
}

variable "keyvault_secret_name_flowable_repo_username" {
  description = "Name of the Azure keyvault secret which holds the Flowable repository username"
  type = string
}

variable "keyvault_secret_name_flowable_repo_password" {
  description = "Name of the Azure keyvault secret which holds the Flowable repository password"
  type = string
}

variable "keyvault_secret_name_flowable_license" {
  description = "Name of the Azure keyvault secret which holds the Flowable license"
  type = string
}

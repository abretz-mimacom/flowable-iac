/**
  * # Azure - Flowable App
  * 
  * This a Terraform module for deploying Flowable services using the [Flowable Helm Chart](https://code.flowable.com/flw-lic/flowable-product/flowable-iac/flowable-iac-helm) 
  * on Azure Kubernetes Service (AKS).
  * See the documentation below for additional info on using this module.
  */
data "azurerm_kubernetes_cluster" "default" {
  name                = var.cluster_name
  resource_group_name = var.cluster_resource_group_name
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.default.kube_admin_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.default.kube_admin_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.default.kube_admin_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.default.kube_admin_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.default.kube_admin_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.default.kube_admin_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.default.kube_admin_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.default.kube_admin_config.0.cluster_ca_certificate)
  }
}

data "azurerm_kubernetes_cluster" "credentials" {
  name                = var.cluster_name
  resource_group_name = var.cluster_resource_group_name
}

data "azurerm_key_vault" "keyvault" {
  name                = var.keyvault_name
  resource_group_name = var.keyvault_resource_group_name
}

data "azurerm_key_vault_secret" "flowable_repo_username" {
  name         = var.keyvault_secret_name_flowable_repo_username
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

data "azurerm_key_vault_secret" "flowable_repo_password" {
  name         = var.keyvault_secret_name_flowable_repo_password
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

data "azurerm_key_vault_secret" "flowable_db_username" {
  name         = var.keyvault_secret_name_flowable_db_username
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

data "azurerm_key_vault_secret" "flowable_db_password" {
  name         = var.keyvault_secret_name_flowable_db_password
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

# Create a secret holding the db credentials
resource "kubernetes_secret" "flowable_db_creds" {
  metadata {
    name      = "flowable-db-creds"
    namespace = var.namespace
  }

  data = {
    flowable-db-username = data.azurerm_key_vault_secret.flowable_db_username.value,
    flowable-db-password = data.azurerm_key_vault_secret.flowable_db_password.value
  }
}

resource "helm_release" "flowable" {
  name                = var.release_name
  namespace           = var.release_namespace
  create_namespace    = var.create_namespace
  repository          = var.helm_repo_url
  repository_username = data.azurerm_key_vault_secret.flowable_repo_username.value
  repository_password = data.azurerm_key_vault_secret.flowable_repo_password.value
  chart               = var.chart_name
  version             = var.chart_version
  atomic              = var.atomic
  verify              = false
  timeout             = var.timeout
  values = [
    "${var.values}"
  ]
}

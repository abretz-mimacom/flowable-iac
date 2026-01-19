locals {
  flowable_repo_username = var.flowable_repo_username != "" ? var.flowable_repo_username : data.azurerm_key_vault_secret.flowable_repo_username.value
  flowable_repo_password = var.flowable_repo_password != "" ? var.flowable_repo_password : data.azurerm_key_vault_secret.flowable_repo_password.value
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

data "azurerm_key_vault_secret" "flowable_license" {
  name         = var.keyvault_secret_name_flowable_license
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

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

resource "kubernetes_namespace" "flowable" {
  metadata {
    name = var.namespace
  }
}

# Create a secret holding the Flowable docker registry authentication
resource "kubernetes_secret" "flowable_docker_auth" {
  metadata {
    name      = var.secret_name_docker_auth
    namespace = var.namespace
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.flowable_docker_registry_server}" = {
          auth = "${base64encode("${local.flowable_repo_username}:${local.flowable_repo_password}")}"
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}

# Create a secret holding the Flowable license
resource "kubernetes_secret" "flowable_license" {
  metadata {
    name      = var.secret_name_flowable_license
    namespace = var.namespace
  }

  data = {
    "flowable.license" = data.azurerm_key_vault_secret.flowable_license.value
  }
}

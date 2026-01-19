output "cluster_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.name
  description = "Name of the cluster"
}

output "cluster_resource_group_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.resource_group_name
  description = "Name of the resource group where the cluster is located"
}

output "ingress_type" {
  value       = "nginx"
  description = "Value used in the ingress configuration of the next modules"
}

output "kubelet_identity_client_id" {
  value       = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].client_id
  description = "Client ID of kubelet_identity generated for this cluster. Needed in prometheus remotewrite configuration."
}
output "kubelet_identity_object_id" {
  value       = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
  description = "Object ID of kubelet_identity generated for this cluster. Needed in keyvault permissions module."
}

output "kubelet_identity_user_assigned_identity_id" {
  value       = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].user_assigned_identity_id
  description = "User Assigned Identity ID of kubelet_identity (long URI) generated for this cluster"
}

output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "Name of the virtual network used for the cluster"
}


# output "cluster_kubeconfig" {
#   value     = data.azurerm_kubernetes_cluster.default.kube_config_raw
#   sensitive = true
#   description = "The kubeconfig that can be used to connect to the cluster"
# }
output "elasticsearch_service_name" {
  description = "Elasticsearch service name"
  value       = "${var.elasticsearch_release_name}-master"
}

output "elasticsearch_service_port" {
  description = "Elasticsearch service port"
  value       = 9200
}

output "elasticsearch_endpoint" {
  description = "Elasticsearch internal endpoint"
  value       = "${var.elasticsearch_release_name}-master.${var.release_namespace}.svc.cluster.local:9200"
}

output "kibana_service_name" {
  description = "Kibana service name"
  value       = "${var.kibana_release_name}-kibana"
}

output "kibana_service_port" {
  description = "Kibana service port"
  value       = 5601
}

output "namespace" {
  description = "Namespace where ELK stack is deployed"
  value       = var.release_namespace
}

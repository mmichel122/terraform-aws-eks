output "kubeconfig" {
  value       = module.cluster.kubeconfig
  description = "EKS Kubeconfig"
}

output "config-map" {
  value       = module.security.config_map_aws_auth
  description = "K8S config map to authorize"
}

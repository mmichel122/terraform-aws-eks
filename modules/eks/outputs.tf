output "cluster_name" {
  description = "EKS cluster name."
  value       = aws_eks_cluster.this.name
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the control plane."
  value       = aws_security_group.cluster_api.id
}

output "cluster_endpoint" {
  description = "Endpoint for the EKS control plane."
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_ca_certificate" {
  description = "Base64 encoded certificate data required to communicate with the cluster."
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

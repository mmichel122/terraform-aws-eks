output "cluster_name" {
  description = "EKS cluster name."
  value       = aws_eks_cluster.this.name
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the control plane."
  value       = aws_security_group.cluster_api.id
}

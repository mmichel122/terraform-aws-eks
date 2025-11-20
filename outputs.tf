output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for the EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_ca_certificate" {
  description = "Base64 encoded certificate data required to communicate with the cluster."
  value       = module.eks.cluster_ca_certificate
}

output "node_group_name" {
  description = "Name of the managed node group."
  value       = module.node_group.node_group_name
}

output "vpc_id" {
  description = "ID of the created VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets used by the cluster."
  value       = module.vpc.public_subnet_ids
}


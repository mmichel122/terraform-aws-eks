variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for the EKS control plane and worker nodes."
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for security groups associated with the EKS cluster."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block used for internal traffic allowance."
  type        = string
}

variable "cluster_role_arn" {
  description = "ARN of the IAM role for the EKS control plane."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster."
  type        = string
}

variable "allow_external_ips" {
  description = "CIDR blocks allowed to reach the public EKS API endpoint."
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to the EKS cluster."
  type        = map(string)
}

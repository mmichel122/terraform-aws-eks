variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for worker nodes."
  type        = list(string)
}

variable "node_role_arn" {
  description = "ARN of the IAM role for worker nodes."
  type        = string
}

variable "desired_size" {
  description = "Desired number of worker nodes."
  type        = number
}

variable "min_size" {
  description = "Minimum number of worker nodes."
  type        = number
}

variable "max_size" {
  description = "Maximum number of worker nodes."
  type        = number
}

variable "instance_types" {
  description = "Instance types for worker nodes."
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to node group resources."
  type        = map(string)
}


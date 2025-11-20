variable "cluster_name" {
  description = "Name of the EKS cluster, used for IAM role naming."
  type        = string
}

variable "tags" {
  description = "Tags to apply to IAM resources."
  type        = map(string)
}


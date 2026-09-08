include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../..//modules/node_group"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    private_subnet_ids = ["subnet-00000000000000003", "subnet-00000000000000004"]
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

dependency "iam" {
  config_path = "../iam"

  mock_outputs = {
    node_role_arn = "arn:aws:iam::123456789012:role/mock-eks-node-role"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

dependency "eks" {
  config_path = "../eks"

  mock_outputs = {
    cluster_name = "demo-eks"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

inputs = {
  cluster_name   = dependency.eks.outputs.cluster_name
  subnet_ids     = dependency.vpc.outputs.private_subnet_ids
  node_role_arn  = dependency.iam.outputs.node_role_arn
  desired_size   = 2
  min_size       = 1
  max_size       = 3
  instance_types = ["t3.small"]
  tags           = { Project = "eks-demo" }
}

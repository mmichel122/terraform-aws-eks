include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../..//modules/eks"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id             = "vpc-00000000000000000"
    public_subnet_ids  = ["subnet-00000000000000001", "subnet-00000000000000002"]
    private_subnet_ids = ["subnet-00000000000000003", "subnet-00000000000000004"]
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

dependency "iam" {
  config_path = "../iam"

  mock_outputs = {
    cluster_role_arn = "arn:aws:iam::123456789012:role/mock-eks-cluster-role"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

inputs = {
  cluster_name       = "demo-eks"
  subnet_ids         = concat(dependency.vpc.outputs.public_subnet_ids, dependency.vpc.outputs.private_subnet_ids)
  vpc_id             = dependency.vpc.outputs.vpc_id
  vpc_cidr           = "10.0.0.0/16"
  cluster_role_arn   = dependency.iam.outputs.cluster_role_arn
  kubernetes_version = "1.30"
  allow_external_ips = ["0.0.0.0/0"]
  tags               = { Project = "eks-demo" }
}

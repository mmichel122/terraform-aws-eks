include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../..//modules/iam"
}

inputs = {
  cluster_name = "demo-eks"
  tags         = { Project = "eks-demo" }
}

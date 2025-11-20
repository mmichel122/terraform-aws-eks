region       = "eu-west-1"
cluster_name = "demo-eks"
vpc_cidr     = "10.0.0.0/16"
public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24",
]
private_subnet_cidrs = [
  "10.0.3.0/24",
  "10.0.4.0/24",
]
eks_version        = "1.30"
node_instance_type = "t3.small"
node_desired_size  = 2
node_min_size      = 1
node_max_size      = 3
allow_external_ips = [
  "2.15.193.179/32",
]
tags = {
  Project = "eks-demo"
}

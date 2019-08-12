provider "aws" {
  region  = "eu-west-2"
  profile = "logging"
}

# Create VPC
module vpc {
  source   = "./VPC"
  vpc_cidr = "${var.vpc_cidr}"
  env      = "${var.env}"
  az_count = "${var.az_count}"
}

# Create security Groups and ELBs.
module network {
  source         = "./network"
  vpc_cidr_block = "${var.vpc_cidr}"
  vpc_main_id    = "${module.vpc.vpc_id}"
  public_subnets = "${module.vpc.public_subnet_ids}"
  cluster-name   = "${var.env}"
}

# Create IAM roles and policies
module "security" {
  source = "./security"
}

# Create EKS Master Cluster
module "cluster" {
  source             = "./cluster"
  vpc_main_id        = "${module.vpc.vpc_id}"
  iam-master-cluster = "${module.security.iam-master-cluster}"
  cluster-name       = "${var.env}"
  master_sg_id       = "${module.network.master_sg_id}"
  private_subnet_1   = "${module.vpc.private_subnet_1}"
  private_subnet_2   = "${module.vpc.private_subnet_2}"
}

# Create nodes
module nodes {
  source                            = "./nodes"
  iam_instance_profile              = "${module.security.iam-instance_profile-node}"
  kube-cluster-id                   = "${module.network.node_sg_id}"
  vpc_main_id                       = "${module.vpc.vpc_id}"
  az_count                          = "${var.az_count}"
  eks-cluster-version               = "${module.cluster.eks-cluster-version}"
  eks-cluster-endpoint              = "${module.cluster.eks-cluster-endpoint}"
  eks-cluster-certificate_authority = "${module.cluster.eks-cluster-certificate_authority}"
  node_key_pair                     = "${var.node_key_pair}"
  cluster-name                      = "${var.env}"
  private_subnet_1                  = "${module.vpc.private_subnet_1}"
  private_subnet_2                  = "${module.vpc.private_subnet_2}"
}

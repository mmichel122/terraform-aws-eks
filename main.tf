terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"

  name                 = var.cluster_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  tags                 = var.tags
}

module "iam" {
  source = "./modules/iam"

  cluster_name = var.cluster_name
  tags         = var.tags
}

module "eks" {
  source = "./modules/eks"

  cluster_name       = var.cluster_name
  subnet_ids         = module.vpc.private_subnet_ids
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = var.vpc_cidr
  cluster_role_arn   = module.iam.cluster_role_arn
  version            = var.eks_version
  allow_external_ips = var.allow_external_ips
  tags               = var.tags
}

module "node_group" {
  source = "./modules/node_group"

  cluster_name   = module.eks.cluster_name
  subnet_ids     = module.vpc.private_subnet_ids
  node_role_arn  = module.iam.node_role_arn
  desired_size   = var.node_desired_size
  min_size       = var.node_min_size
  max_size       = var.node_max_size
  instance_types = [var.node_instance_type]
  tags           = var.tags
}

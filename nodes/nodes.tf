provider "aws" {
  region  = "eu-west-2"
  profile = "logging"
}

/*
data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.k8s-version}-*"]
  }

  most_recent = true
  owners      = ["548894310305"] # Amazon EKS AMI Account ID
}
*/

data "aws_region" "current" {}

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We implement a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  kube-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${var.eks-cluster-endpoint}' --b64-cluster-ca '${var.eks-cluster-certificate_authority}' '${var.cluster-name}'
yum update -y
yum install -y amazon-efs-utils
USERDATA
}

resource "aws_launch_configuration" "kube" {
  associate_public_ip_address = false
  iam_instance_profile = "${var.iam_instance_profile}"
  image_id = "ami-0147919d2ff9a6ad5"
  instance_type = "t3a.medium"
  name_prefix = "kube-nodes"
  key_name = "${var.node_key_pair}"
  security_groups = ["${var.kube-cluster-id}"]
  user_data_base64 = "${base64encode(local.kube-node-userdata)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "kube" {
  desired_capacity = 2
  launch_configuration = "${aws_launch_configuration.kube.id}"
  max_size = 2
  min_size = 1
  name = "kube-nodes"
  vpc_zone_identifier = ["${var.private_subnet_1}", "${var.private_subnet_2}"]

  health_check_type = "EC2"

  tag {
    key = "Name"
    value = "kube-nodes"
    propagate_at_launch = true
  }

  tag {
    key = "kubernetes.io/cluster/${var.cluster-name}"
    value = "owned"
    propagate_at_launch = true
  }
}

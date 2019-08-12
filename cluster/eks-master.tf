provider "aws" {
  region  = "eu-west-2"
  profile = "logging"
}

resource "aws_eks_cluster" "kube" {
  name     = "${var.cluster-name}"
  role_arn = "${var.iam-master-cluster}"

  vpc_config {
    security_group_ids = ["${var.master_sg_id}"]
    subnet_ids         = ["${var.public_subnet_1}", "${var.public_subnet_2}"]
  }
}

# kubeconfig file
locals {
  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.kube.endpoint}
    certificate-authority-data: ${aws_eks_cluster.kube.certificate_authority.0.data}
  name: "${var.cluster-name}"
contexts:
- context:
    cluster: "${var.cluster-name}"
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.cluster-name}"
KUBECONFIG
}

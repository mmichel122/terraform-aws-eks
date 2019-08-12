output "eks-cluster-version" {
  value = "${aws_eks_cluster.kube.version}"
}

output "eks-cluster-endpoint" {
  value = "${aws_eks_cluster.kube.endpoint}"
}

output "eks-cluster-certificate_authority" {
  value = "${aws_eks_cluster.kube.certificate_authority.0.data}"
}

output "kubeconfig" {
  value = "${local.kubeconfig}"
}

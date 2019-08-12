output "iam-master-cluster" {
  value = "${aws_iam_role.master-cluster.arn}"
}

output "iam-cluster-node" {
  value = "${aws_iam_role.cluster-node.arn}"
}

output "iam-instance_profile-node" {
  value = "${aws_iam_instance_profile.cluster-node.name}"
}

output "config_map_aws_auth" {
  value = "${local.config_map_aws_auth}"
}

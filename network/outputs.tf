output "node_sg_id" {
  value = "${aws_security_group.node_sg.id}"
}
output "master_sg_id" {
  value = "${aws_security_group.kube-cluster.id}"
}

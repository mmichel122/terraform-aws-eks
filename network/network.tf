provider "aws" {
  region  = "eu-west-2"
  profile = "logging"
}

# Cluster Security Group
resource "aws_security_group" "kube-cluster" {
  name        = "Master-Security_SG"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${var.vpc_main_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Master-Security_SG"
  }
}

resource "aws_security_group_rule" "master-cluster-ingress-workstation-https" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.kube-cluster.id}"
  to_port           = 443
  type              = "ingress"
}

# Node Private Security Group
resource "aws_security_group" "node_sg" {
  name        = "Node_Security_SG"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${var.vpc_main_id}"

  #SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
      "Name", "Node_Security_SG",
      "kubernetes.io/cluster/${var.cluster-name}", "owned",
    )
  }"
}

resource "aws_security_group_rule" "node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.node_sg.id}"
  source_security_group_id = "${aws_security_group.node_sg.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.node_sg.id}"
  source_security_group_id = "${aws_security_group.kube-cluster.id}"
  to_port                  = 65535
  type                     = "ingress"
}

/*
# Node ELB
resource "aws_elb" "kube-cp" {
  name            = "node-elb"
  security_groups = ["${aws_security_group.node_sg.id}"]
  subnets         = var.public_subnets
  internal        = true

  listener {
    instance_port     = 22
    instance_protocol = "tcp"
    lb_port           = 22
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    target              = "TCP:22"
    interval            = 30
  }

  instances                   = var.instance_ids
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}
*/

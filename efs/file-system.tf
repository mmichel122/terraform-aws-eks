provider "aws" {
  region  = "eu-west-2"
  profile = "logging"
}

resource "aws_efs_file_system" "kube_efs" {
  creation_token   = "kube-efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"

  tags = {
    Name = "Kube File System"
  }
}

resource "aws_efs_mount_target" "kube_efs_mount_1" {
  file_system_id = "${aws_efs_file_system.kube_efs.id}"
  subnet_id      = "${var.kube_subnet_1}"
}

resource "aws_efs_mount_target" "kube_efs_mount_2" {
  file_system_id = "${aws_efs_file_system.kube_efs.id}"
  subnet_id      = "${var.kube_subnet_2}"
}

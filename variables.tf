variable "vpc_cidr" {
  default = "10.133.0.0/16"
}

variable "env" {
  default = "KubeCloud"
}

variable "az_count" {
  default = "2"
}

variable "node_key_pair" {
  default = "LinuxAppKey"
}

variable "profile" {
  default = "logging"
}


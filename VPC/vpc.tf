provider "aws" {
  region  = "eu-west-2"
  profile = "logging"
}

# Get AZs
data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"

  tags = {
    Name = "${var.env}_VPC"
    Env  = "${var.env}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "${var.env}_GW"
    Env  = "${var.env}"
  }
}

resource "aws_subnet" "public" {
  count             = "${var.az_count}"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr, 8, count.index + 1)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags = {
    Name                     = "Public_Subnet_${count.index + 1}"
    Type                     = "Public"
    KubernetesCluster        = "${var.env}"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_eip" "nat" {
  count = "${length(aws_subnet.public)}"
  vpc   = true
}

resource "aws_nat_gateway" "nat" {
  count         = "${length(aws_subnet.public)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
}

resource "aws_subnet" "private" {
  count             = "${var.az_count}"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr, 8, count.index + 11)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags = {
    Name              = "Private_Subnet_${count.index + 1}"
    KubernetesCluster = "${var.env}"
    Type              = "Private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name = "Public Route ${var.env}"
    Env  = "${var.env}"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(aws_subnet.public)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table" "private" {
  count  = "${length(aws_subnet.private)}"
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${element(aws_nat_gateway.nat.*.id, count.index)}"
  }

  tags = {
    Name = "Private Route ${count.index} ${var.env}"
    Env  = "${var.env}"
  }
}

resource "aws_route_table_association" "private" {
  count          = "${length(aws_subnet.private)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

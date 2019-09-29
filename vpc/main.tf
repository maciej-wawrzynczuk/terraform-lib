variable "project" {}

output "subnet_id" {
  value = aws_subnet.default.id
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  assign_generated_ipv6_cidr_block = true
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    project = "${var.project}"
  }
}

resource "aws_subnet" "default" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${cidrsubnet(aws_vpc.default.cidr_block, 8, 0)}"
  map_public_ip_on_launch = true
  ipv6_cidr_block = "${cidrsubnet(aws_vpc.default.ipv6_cidr_block, 8, 0)}"
  assign_ipv6_address_on_creation = true
  tags = {
    project = "${var.project}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_default_route_table" "r" {
  default_route_table_id = "${aws_vpc.default.default_route_table_id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  
  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.gw.id
    }
}

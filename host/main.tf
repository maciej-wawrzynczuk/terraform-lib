variable "ami_id" {}
variable "project" {}
variable "subnet_id" {}
variable "key_name" {}
variable "number" {}
variable "tcp_ports" {}

output "ips" {
  value = aws_instance.host[*].public_ip
}

output "ips6" {
  value = "${flatten(aws_instance.host[*].ipv6_addresses)}"
}

#I need it for triggering provisioning
output "ids" {
  value = aws_instance.host[*].id
}

#get vpc id from the subnet

data "aws_subnet" "subnet" {
  id = "${var.subnet_id}"
}

resource "aws_security_group" "sg" {
  vpc_id = "${data.aws_subnet.subnet.vpc_id}"
  name = "${var.project}-sg"
}

resource "aws_security_group_rule" "egress" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sg.id}"
}

resource "aws_security_group_rule" "egress6" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = "${aws_security_group.sg.id}"
}

resource "aws_security_group_rule" "ingress" {
  count = "${length(var.tcp_ports)}"
  type = "ingress"
  from_port = "${var.tcp_ports[count.index]}"
  to_port = "${var.tcp_ports[count.index]}"
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sg.id}"
}

resource "aws_security_group_rule" "ingress6" {
  count = "${length(var.tcp_ports)}"
  type = "ingress"
  from_port = "${var.tcp_ports[count.index]}"
  to_port = "${var.tcp_ports[count.index]}"
  protocol = "tcp"
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = "${aws_security_group.sg.id}"
}



resource "aws_instance" "host" {
  count = "${var.number}"
  ami = "${var.ami_id}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  subnet_id = "${var.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.sg.id}"]
  tags = {
    project = "${var.project}"
    Name = "${var.project}-host${count.index}"
  }

  #Does nothing. Just wait for instance to be ready before provision.
  provisioner "remote-exec" {
    inline = [
      "true"
    ]
    
    connection {
      type = "ssh"
      host = "${self.public_ip}"
      user = "ubuntu"
      timeout = "1m"
    }
  }
}

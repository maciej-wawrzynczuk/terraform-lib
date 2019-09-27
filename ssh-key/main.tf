variable "project" {}

output key_name {
  value = aws_key_pair.kp.key_name
}

resource "aws_key_pair" "kp" {
  key_name = "${var.project}"
  public_key = file(pathexpand("~/.ssh/id_rsa.pub"))
}

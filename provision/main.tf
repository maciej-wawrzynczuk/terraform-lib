variable "hosts" {
  type = list(string)
}

variable "trigger" {}
variable "playbook" {}

locals {
  inv_string = "${format("%s,", join(",", var.hosts))}"
}

resource "null_resource" "provision" {
  triggers = {
    trigger = "${var.trigger}"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${local.inv_string} ${var.playbook} --user ubuntu"
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }
}

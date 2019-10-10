variable "domain" {}
variable "hostnames" {}
variable "addresses" {}
variable "addresses6" {}

output "fqdn" {
  value = aws_route53_record.record[*].name
}


data "aws_route53_zone" "zone" {
  name = "${var.domain}"
}

locals {
  count = "${length(var.addresses)}"
}

resource "aws_route53_record" "record" {
  count = "${local.count}"
  zone_id = "${data.aws_route53_zone.zone.id}"
  name = "${var.hostnames[count.index]}.${data.aws_route53_zone.zone.name}"
  type = "A"
  ttl = "300"
  records = ["${var.addresses[count.index]}"]
}

resource "aws_route53_record" "record6" {
  count = "${local.count}"
  zone_id = "${data.aws_route53_zone.zone.id}"
  name = "${var.hostnames[count.index]}.${data.aws_route53_zone.zone.name}"
  type = "AAAA"
  ttl = "300"
  records = ["${var.addresses6[count.index]}"]
}

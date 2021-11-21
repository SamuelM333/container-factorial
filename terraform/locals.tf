locals {
  service_name = "container-factorial"
  service_port = 8080
  azs          = ["${var.region}a", "${var.region}b", "${var.region}c", "${var.region}d", "${var.region}e", "${var.region}f"]
}

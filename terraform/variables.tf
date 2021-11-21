variable "region" {
  type        = string
  description = "The AWS region"
  default     = "us-east-1"
}

variable "ingress_cidr_blocks" {
  type        = list(string)
  description = "Allowed ingress CIDR blocks for the service security group"
}


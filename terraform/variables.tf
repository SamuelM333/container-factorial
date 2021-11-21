variable "region" {
  type        = string
  description = "The AWS region"
  default     = "us-east-1"
}

# VPC

variable "ingress_cidr_blocks" {
  type        = list(string)
  description = "Allowed ingress CIDR blocks for the service security group"
}

# IAM

variable "principal" {
  description = "ARN of the principal account"
}

# ECR

variable "scan_on_push" {
  type        = bool
  description = "Enable vulnerability scanning when an image is pushed."
  default     = true
}

variable "max_number_tagged_images" {
  type        = number
  description = "Maximum number of tagged images to keep in ECR before expiring"
  default     = 30
}

variable "max_days_untagged_images" {
  type        = number
  description = "Maximum number of days before an untagged image is expired in ECR"
  default     = 30
}

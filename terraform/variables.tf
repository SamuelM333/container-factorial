variable "region" {
  type        = string
  description = "The AWS region"
  default     = "us-east-1"
}

# VPC

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

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

# ECS
variable "ecs_desired_count" {
  type        = number
  description = "The desired amount of tasks for the ECS service"
  default     = 0
}

variable "ecs_deployment_maximum_percent" {
  type        = number
  description = "Determines how many running containers can be deployed as a percentage of desired_count"
  default     = 150

  validation {
    condition     = var.ecs_deployment_maximum_percent - 100 > 0
    error_message = "Must be at least 100. Minimum healthy percent determined based on this condition as well."
  }
}

variable "ecs_container_cpu" {
  type        = number
  description = "CPU allocation for service container definition"
  default     = 256
}

variable "ecs_container_memory" {
  type        = number
  description = "Memory allocation for service container definition"
  default     = 512
}

variable "ecs_service_cpu" {
  type        = number
  description = "CPU allocation for service task definition"
  default     = 256
}

variable "ecs_service_memory" {
  type        = number
  description = "Memory allocation for service task definition"
  default     = 512
}

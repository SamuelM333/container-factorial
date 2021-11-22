output "url" {
  value       = module.alb.lb_dns_name
  description = "ALB URL"
}

output "ecr_url" {
  value       = aws_ecr_repository.this.repository_url
  description = "ECR URL"
}

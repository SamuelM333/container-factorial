data "aws_vpc" "this" {
  default = true
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.this.id
}

module "security_group_alb" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name            = "${local.service_name}-alb"
  description     = "Security Group for ${local.service_name} ALB"
  use_name_prefix = false
  vpc_id          = data.aws_vpc.this.id

  ingress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp"
      cidr_blocks = join(",", var.ingress_cidr_blocks)
    },
  ]

  egress_with_source_security_group_id = [{
    rule                     = "all-all"
    source_security_group_id = module.security_group_service.security_group_id
  }]
}

module "security_group_service" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name            = local.service_name
  description     = "Security Group for ${local.service_name}"
  use_name_prefix = false
  vpc_id          = data.aws_vpc.this.id

  ingress_with_source_security_group_id = [{
    from_port                = local.service_port
    to_port                  = local.service_port
    protocol                 = "tcp"
    description              = "Service port"
    source_security_group_id = module.security_group_alb.security_group_id
  }]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["http-80-tcp"]
}

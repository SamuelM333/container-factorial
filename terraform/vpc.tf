resource "aws_eip" "nat" {
  count = 3

  vpc = true
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.11"

  name = "simple"
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  reuse_nat_ips       = true
  external_nat_ip_ids = aws_eip.nat.*.id

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = false

  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_dhcp_options  = true

  manage_default_network_acl = true

  public_subnet_tags = {
    Type = "public"
  }

  private_subnet_tags = {
    Type = "private"
  }

  vpc_tags = {
    Name = "simple"
  }
}

module "security_group_alb" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name            = "${local.service_name}-alb"
  description     = "Security Group for ${local.service_name} ALB"
  use_name_prefix = false
  vpc_id          = module.vpc.vpc_id

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
  vpc_id          = module.vpc.vpc_id

  ingress_with_source_security_group_id = [{
    from_port                = local.service_port
    to_port                  = local.service_port
    protocol                 = "tcp"
    description              = "Service port"
    source_security_group_id = module.security_group_alb.security_group_id
  }]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["https-443-tcp", "http-80-tcp"]
}

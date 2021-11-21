module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name               = "${local.service_name}-alb"
  load_balancer_type = "application"

  vpc_id          = data.aws_vpc.this.id
  subnets         = data.aws_subnet_ids.public.ids
  security_groups = [module.security_group_alb.security_group_id]

  target_groups = [
    {
      target_type      = "ip"
      backend_protocol = "HTTP"
      backend_port     = local.service_port
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
}

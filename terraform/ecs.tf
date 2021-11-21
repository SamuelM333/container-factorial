module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 3.4"

  name               = local.service_name
  container_insights = true
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy = [{
    capacity_provider = "FARGATE"
    weight            = "1"
  }]
}

resource "aws_ecs_task_definition" "this" {
  family                   = local.service_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_service_cpu
  memory                   = var.ecs_service_memory
  task_role_arn            = module.ecs_task_role.iam_role_arn
  execution_role_arn       = module.ecs_execution_role.iam_role_arn

  container_definitions = jsonencode([
    module.container.json_map_object
  ])
}

resource "aws_ecs_service" "this" {
  name    = local.service_name
  cluster = module.ecs.ecs_cluster_id

  task_definition = aws_ecs_task_definition.this.family
  launch_type     = "FARGATE"

  desired_count = var.ecs_desired_count

  deployment_maximum_percent         = var.ecs_deployment_maximum_percent
  deployment_minimum_healthy_percent = var.ecs_deployment_maximum_percent - 100

  load_balancer {
    target_group_arn = module.alb.target_group_arns[0]
    container_name   = local.service_name
    container_port   = local.service_port
  }

  network_configuration {
    subnets          = data.aws_subnet_ids.public.ids
    security_groups  = [module.security_group_service.security_group_id]
    assign_public_ip = false
  }
}

module "container" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "~> 0.58"

  container_name               = local.service_name
  container_image              = "${aws_ecr_repository.this.repository_url}:latest"
  container_memory_reservation = var.ecs_container_memory
  container_cpu                = var.ecs_container_cpu
  essential                    = true

  port_mappings = [
    {
      "hostPort" : local.service_port,
      "protocol" : "tcp",
      "containerPort" : local.service_port
    }
  ]

  log_configuration = {
    "logDriver" : "awslogs",
    "options" : {
      "awslogs-group" : "/aws/ecs/${local.service_name}"
      "awslogs-region" : var.region,
      "awslogs-stream-prefix" : "ecs"
    }
  }
}

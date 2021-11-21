data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ecr" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
    ]
    resources = [aws_ecr_repository.this.arn]
  }

  statement {
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecr" {
  name   = "${local.service_name}-ecs-ecr"
  policy = data.aws_iam_policy_document.ecr.json
}

data "aws_iam_policy_document" "logs" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/ecs/containerinsights/${local.service_name}*",
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/ecs/${local.service_name}*"
    ]
  }
}

resource "aws_iam_policy" "logs" {
  name   = "${local.service_name}-ecs-logs"
  policy = data.aws_iam_policy_document.logs.json
}

module "ecs_execution_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 4.0"

  trusted_role_services = ["ecs-tasks.amazonaws.com"]

  create_role = true

  role_name         = "${local.service_name}-execution-role"
  role_requires_mfa = false

  custom_role_policy_arns = [
    aws_iam_policy.ecr.arn,
    aws_iam_policy.logs.arn,
  ]
}

module "ecs_task_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 4.0"

  trusted_role_services = ["ecs-tasks.amazonaws.com"]

  create_role = true

  role_name         = "${local.service_name}-task-role"
  role_requires_mfa = false

  custom_role_policy_arns = [aws_iam_policy.ecr.arn]
}

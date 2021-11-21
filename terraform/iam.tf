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

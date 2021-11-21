resource "aws_ecr_repository" "this" {
  name = local.service_name

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = templatefile("${path.module}/ecr_lifecycle_policy.hcl", {
    max_number_tagged_images = var.max_number_tagged_images,
    max_days_untagged_images = var.max_days_untagged_images
  })
}

resource "aws_ecr_repository_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy     = data.aws_iam_policy_document.ecr_repo.json
}

data "aws_iam_policy_document" "ecr_repo" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [var.principal]
    }

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:ListImages",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
  }
}

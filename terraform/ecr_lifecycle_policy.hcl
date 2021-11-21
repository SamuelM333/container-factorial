${jsonencode({
    "rules": [
      {
        "rulePriority": 1,
        "description": "Keep max_number_tagged_images tagged images", 
        "selection": {
          "tagStatus": "tagged",
          "tagPrefixList": ["container-factorial-"],
          "countType": "imageCountMoreThan",
          "countNumber": max_number_tagged_images
        },
        "action": {
          "type": "expire"
        }
      },
      {
        "rulePriority": 2,
        "description": "Keep untagged images for max_days_untagged_images days",
        "selection": {
          "tagStatus": "untagged",
          "countType": "sinceImagePushed",
          "countUnit": "days",
          "countNumber": max_days_untagged_images
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  })}

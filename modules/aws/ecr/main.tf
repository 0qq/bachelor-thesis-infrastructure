# modules/aws/ecr/main.tf

locals {
  tags = merge(var.tags, { Terraform_module = "ecr" })
}


data "aws_ecr_authorization_token" "this" {
  registry_id = aws_ecr_repository.this.registry_id
}


resource "aws_ecr_repository" "this" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.tags
}


resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = <<-POLICY
  {
    "rules": [
      {
        "rulePriority": 1,
        "description": "keep last 10 untagged images",
        "selection": {
          "tagStatus": "untagged",
          "countType": "imageCountMoreThan",
          "countNumber": 10
        },
        "action": {
          "type": "expire"
        }
      },
      {
        "rulePriority": 2,
        "description": "keep last 20 tagged images",
        "selection": {
          "tagStatus": "tagged",
          "tagPrefixList": ["v"],
          "countType": "imageCountMoreThan",
          "countNumber": 20
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
  POLICY
}

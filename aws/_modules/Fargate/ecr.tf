resource "aws_ecr_repository" "oak9-ecr" {
  name = var.ecr_repository_name
}

resource "aws_ecr_lifecycle_policy" "oak9-ecr" {
  repository = aws_ecr_repository.oak9-ecr.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
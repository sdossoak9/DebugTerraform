data "aws_iam_policy_document" "ecr_readonly_access" {
  statement {
    sid    = "ReadonlyAccess"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:PrincipalOrgID"
      # This is our organization-wide identifier which can be found after
      # log-in to AWS: <https://console.aws.amazon.com/organizations/home>
      values = ["o-ca3btxlrpf"]
    }

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:DescribeImageScanFindings",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]
  }
}

data "aws_iam_policy_document" "ecr_access" {
  source_json   = data.aws_iam_policy_document.ecr_readonly_access.json
}

# If the image needs to be pushed/available to all environments, give the repo access to the repo policy above

resource "aws_ecr_repository" "argocd-ecr" {
  name = var.argocd_repo_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "functionbeat-ecr" {
  name = var.functionbeat_repo_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "grpc-dotnet-ecr" {
  name = var.grpc_dotnet_repo_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "grpc-python-ecr" {
  name = var.grpc_python_repo_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "jenkins-docker-ecr" {
  name = var.jenkins_docker_repo_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "jenkins-dotnet-ecr" {
  name = var.jenkins_dotnet_repo_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "jenkins-go-ecr" {
  name = var.jenkins_go_repo_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "jenkins-grpc-ecr" {
  name = var.jenkins_grpc_repo_name

  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    encryption_type = var.kms
  }
}

resource "aws_ecr_repository" "jenkins-grpc-python-ecr" {
  name = var.jenkins_grpc_python_repo_name

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = var.kms
  }
}

resource "aws_ecr_repository" "jenkins-lambda-ecr" {
  name = var.jenkins_lambda_repo_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "jenkins-node-ecr" {
  name = var.jenkins_node_repo_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "jenkins-terraform-ecr" {
  name = var.jenkins_terraform_repo_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "k8sops-ecr" {
  name = var.k8sops_repo_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "sac-grpc-ecr" {
  name = var.grpc_ecr_repo_name

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = var.kms
  }
}

resource "aws_ecr_repository" "sac-blueprints-ecr" {
  name = var.sac_blueprints_repo_name
}

resource "aws_ecr_repository_policy" "sac-grpc-ecr-policy" {
  repository = var.grpc_ecr_repo_name
  policy     = data.aws_iam_policy_document.ecr_access.json
}

resource "aws_ecr_repository" "sac-brs-ecr" {
  name = var.brs_ecr_repo_name
}

resource "aws_ecr_repository_policy" "sac-brs-ecr-policy" {
  repository = var.brs_ecr_repo_name
  policy     = data.aws_iam_policy_document.ecr_access.json
}

resource "aws_ecr_repository" "console-api-ecr" {
  name = var.console_api_ecr_repo_name
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository_policy" "oak9-console-api" {
  repository = var.console_api_ecr_repo_name
  policy     = data.aws_iam_policy_document.ecr_access.json
}

resource "aws_ecr_repository" "oak9-dev-ecr" {
  name = var.dev_ecr_repo_name
}

resource "aws_ecr_repository" "oak9-jenkins-ecr" {
  name = var.oak9_jenkins_repo_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "oak9-sac-async-ecr" {
  name = var.oak9_sac_async_repo_name
}

resource "aws_ecr_repository" "oak9-sac-queue-ecr" {
  name = var.oak9_sac_queue_repo_name
}

resource "aws_ecr_repository" "tfops-ecr" {
  name = var.tfops_repo_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "pytest-ecr" {
  name = var.pytest_repo_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "jenkins-dotnet6-upgrade" {
  name = var.dotnet6_upgrade
}

resource "aws_ecr_repository_policy" "jenkins-dotnet6-upgrade" {
  repository = var.dotnet6_upgrade
  policy     = data.aws_iam_policy_document.ecr_access.json
}
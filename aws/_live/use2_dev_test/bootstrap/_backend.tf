terraform {
  required_version = ">= 0.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.36.0"
    }
  }

  backend "s3" {
    bucket         = "oak9-devtest-terraform-bootstrap-state-backend"
    key            = "use2_devtest/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "oak9-devtest-terraform-bootstrap-state-lock"
    profile        = "test"
  }
}

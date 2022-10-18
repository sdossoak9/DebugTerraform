terraform {
  backend "s3" {
    bucket         = "oak9-prod-terraform-state-backend"
    key            = "use2_prod/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "oak9-terraform-state-lock-prod"
    profile        = "prod"
  }
}

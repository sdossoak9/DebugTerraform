terraform {
  backend "s3" {
    bucket         = "oak9-dev-terraform-state-backend"
    key            = "use2_stage/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "oak9-dev-terraform-lock"
    profile        = "dev"
  }
}

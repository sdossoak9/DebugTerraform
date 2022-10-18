terraform {
  backend "s3" {
    bucket         = "oak9-dev-terraform-bootstrap-state-backend"
    key            = "use2_dev/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "oak9-dev-terraform-bootstrap-state-lock"
    profile        = "dev"
  }
}

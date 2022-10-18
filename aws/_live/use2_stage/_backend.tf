terraform {
  backend "s3" {
    bucket         = "oak9-stage-terraform-state-backend"
    key            = "use2_stage/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "oak9-terraform-state-lock-stage"
    profile        = "staging"
  }
}

terraform {
  backend "s3" {
    bucket         = "oak9-security-terraform-state-backend"
    key            = "use2_security/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "oak9-security-terraform-lock"
    profile        = "security"
  }
}

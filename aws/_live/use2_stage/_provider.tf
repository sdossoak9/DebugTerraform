provider "aws" {
  region  = var.region
  profile = var.profile
}

provider "aws" {
  profile = var.profile
  alias   = "cloudfront-acm-certs"
  region  = "us-east-1"
}

provider "aws" {
  profile = var.profile
  alias   = "cloudfront-acm-certs-ohio"
  region  = "us-east-2"
}

provider "aws" {
  alias   = "backup"
  region  = "us-east-1"
  profile = var.profile
}

provider "aws" {
  profile = var.profile
  alias   = "production"
  region  = "us-east-2"

  assume_role {
    role_arn = "arn:aws:iam::164810006412:role/terraform"
  }
}

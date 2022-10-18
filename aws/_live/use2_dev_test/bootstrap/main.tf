module "terraform_state_backend" {
  count      = 0
  source     = "cloudposse/tfstate-backend/aws"
  version    = "0.33.0"
  namespace  = "oak9"
  stage      = var.environment
  name       = "oak9"
  attributes = ["state"]

  terraform_backend_config_file_path = "../"
  terraform_backend_config_file_name = "s3backend.tf"
  terraform_state_file               = "backup/terraform.tfstate"
  s3_bucket_name                     = "oak9-s3backend-${var.environment}"
  force_destroy                      = false
}

module "Iam" {
  count  = 1
  source = "../../../_modules/Iam"
}

module "Backup" {
  providers = {
    aws        = aws,
    aws.backup = aws.backup
  }
  count       = 1
  source      = "../../../_modules/Backup"
  region      = var.region
  environment = var.environment
  url         = "console.oak9.cloud"
}

module "Ssm" {
  count              = 1
  source             = "../../../_modules/Ssm"
  environment        = var.environment
  asp_environment    = var.asp_environment
  idpUri             = var.idpUri
  idpClient          = var.idpClient
  s3AccessKey        = var.s3AccessKey
  s3AccessSecret     = var.s3AccessSecret
  orgRepoAccessToken = var.orgRepoAccessToken
  orgRepoUserId      = var.orgRepoUserId
  kibana_pass        = var.kibana_pass
}

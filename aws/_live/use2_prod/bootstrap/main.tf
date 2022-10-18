module "Iam" {
  count  = 1
  source = "../../../_modules/Iam"
}

module "Ssm" {
  count              = 1
  source             = "../../../_modules/Ssm"
  environment        = "prod"
  asp_environment    = var.asp_environment
  idpUri             = var.idpUri
  idpClient          = var.idpClient
  s3AccessKey        = var.s3AccessKey
  s3AccessSecret     = var.s3AccessSecret
  orgRepoAccessToken = var.orgRepoAccessToken
  orgRepoUserId      = var.orgRepoUserId
}

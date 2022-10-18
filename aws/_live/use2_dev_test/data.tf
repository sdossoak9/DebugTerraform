data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ssm_parameter" "environment" {
  name = "environment"
}

data "aws_ssm_parameter" "asp_environment" {
  name = "asp_environment"
}

data "aws_ssm_parameter" "idpClient" {
  name = "idpClient"
}

data "aws_ssm_parameter" "idpUri" {
  name = "idpUri"
}

data "aws_ssm_parameter" "s3AccessKey" {
  name = "s3AccessKey"
}

data "aws_ssm_parameter" "s3AccessSecret" {
  name = "s3AccessSecret"
}

data "aws_ssm_parameter" "orgRepoAccessToken" {
  name = "orgRepoAccessToken"
}

data "aws_ssm_parameter" "orgRepoUserId" {
  name = "orgRepoUserId"
}

data "aws_ssm_parameter" "kibana_pass" {
  name = "kibana_pass"
}

data "aws_acm_certificate" "oak9Cloud" {
  domain   = "*.oak9.cloud"
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "oak9CloudVirginia" {
  provider = aws.cloudfront-acm-certs
  domain   = "*.oak9.cloud"
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "oak9CloudOhio" {
  provider = aws.cloudfront-acm-certs-ohio
  domain   = "*.oak9.cloud"
  statuses = ["ISSUED"]
}
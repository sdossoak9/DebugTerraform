module "ApiGateway" {
  source                   = "../../_modules/ApiGateway"
  depends_on               = [module.Buckets.assest_bucket]
  region                   = var.region
  environment              = var.environment
  stage_name               = var.environment
  aws_api_gateway_rest_api = "oak9-${var.environment}-lambdaAndConsoleApi-gateway"
  vpc_connection_id        = module.Fargate.vpc_connection_id
  lambda_details           = module.Lambda.functions_details
  acm_certificate_arn      = data.aws_acm_certificate.oak9CloudVirginia.arn
}

module "Websocket" {
  source                   = "../../_modules/Websocketapi"
  depends_on               = [module.Buckets.assest_bucket]
  region                   = var.region
  environment              = var.environment
  stage_name               = var.environment
  aws_api_gateway_websocket_api = "oak9-${var.environment}-WebsocketOrchestrator"
  lambda_details           = module.Lambda.functions_details
  acm_certificate_arn      = data.aws_acm_certificate.oak9CloudOhio.arn
}

module "Buckets" {
  providers = {
    aws        = aws,
    aws.backup = aws.backup
  }
  source        = "../../_modules/Buckets"
  region        = var.region
  environment   = var.environment
  url           = "console.oak9.cloud"
  s3Bucket      = "oak9-${var.environment}-deployment-assets"
  force_destroy = true
}

module "CloudFront" {
  source              = "../../_modules/CloudFront"
  region              = var.region
  environment         = var.environment
  ui_s3Bucket         = "oak9-console-ui-${var.environment}"
  root_object_path    = "/ui-deployment"
  acm_certificate_arn = data.aws_acm_certificate.oak9CloudVirginia.arn
}

module "DynamoDB" {
  source             = "../../_modules/DynamoDB"
  region             = var.region
  environment        = var.environment
  db_backup_s3Bucket = "oak9-dynamodb-backup-${var.environment}"
  enable_POITB       = false # Enable point in time back up for dynamoDB tables
}

module "Fargate" {
  source                        = "../../_modules/Fargate"
  region                        = var.region
  environment                   = var.environment
  project_name                  = "oak9"
  aws_api_gateway_rest_api      = "oak9-${var.environment}-console-gateway"
  ecr_repository_name           = "oak9-${var.environment}-ecr"
  link_aws_api_gateway_vpc_link = "api-vpc-link-${var.environment}"
  max_instance                  = 6
  min_instance                  = 2
}

module "Lambda" {
  source            = "../../_modules/Lambda"
  depends_on        = [module.Buckets.assest_bucket]
  region            = var.region
  environment       = var.environment
  s3Bucket          = "oak9-${var.environment}-deployment-assets"
  default_file_path = "${path.root}/../../_modules/utils/aspnetcore.zip"
  environment_vars = {
    asp_environment    = data.aws_ssm_parameter.asp_environment.value
    idpUri             = data.aws_ssm_parameter.idpUri.value
    idpClient          = data.aws_ssm_parameter.idpClient.value
    s3AccessKey        = data.aws_ssm_parameter.s3AccessKey.value
    s3AccessSecret     = data.aws_ssm_parameter.s3AccessSecret.value
    orgRepoAccessToken = data.aws_ssm_parameter.orgRepoAccessToken.value
    orgRepoUserId      = data.aws_ssm_parameter.orgRepoUserId.value
  }
  account_id = data.aws_caller_identity.current.account_id
  # s3Key = "asp_net/"
}

module "Sns" {
  source         = "../../_modules/Sns"
  region         = var.region
  environment    = var.environment
  lambda_details = module.Lambda.functions_details
}

module "DNS_cloudfront" {
  providers = { aws = aws.production }
  source    = "../../_modules/Route53"
  url       = "${var.environment}console.oak9.cloud"
  type      = "CNAME"
  value     = [module.CloudFront.cloudfront_details.domain_name]
}

module "DNS_apigateway" {
  providers = { aws = aws.production }
  source    = "../../_modules/Route53"
  url       = "${var.environment}console-api.oak9.cloud"
  type      = "CNAME"
  value     = [module.ApiGateway.apigateway_domain_name]
}

module "DNS_apigateway_websocket" {
  providers = { aws = aws.production }
  source    = "../../_modules/Route53"
  url       = "${var.environment}websocket-api.oak9.cloud"
  type      = "CNAME"
  value     = [module.Websocket.apigateway_domain_name]
}

module "Ses" {
  source = "../../_modules/Ses"
}
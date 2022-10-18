module "Iam" {
  count  = 1
  source = "../../_modules/Iam"
}
module "ApiGateway" {
  source                   = "../../_modules/ApiGateway"
  depends_on               = [module.Buckets.assest_bucket]
  region                   = var.region
  dns_name                 = var.dns_name
  stack                    = var.stack
  stage_name               = var.stage_name
  base_path                = var.base_path
  aws_api_gateway_rest_api = "oak9-${var.environment}-lambdaAndConsoleApi-gateway"
  vpc_connection_id        = module.Fargate.vpc_connection_id
  lambda_details           = module.Lambda.functions_details
  acm_certificate_arn      = data.aws_acm_certificate.oak9CloudVirginia.arn
}

module "AzureApiGateway" {
  source = "../../_modules/AzureMarketplaceApi"
  # depends_on               = [module.Buckets.assest_bucket]
  region                   = var.region
  dns_name                 = var.dns_name
  stack                    = var.stack
  base_path                = var.base_path
  aws_api_gateway_rest_api = "oak9-${var.environment}-AzureMarketplace"
  lambda_details           = module.Lambda.functions_details
  acm_certificate_arn      = data.aws_acm_certificate.oak9CloudVirginia.arn
}

module "Websocket" {
  source                        = "../../_modules/Websocketapi"
  depends_on                    = [module.Buckets.assest_bucket]
  region                        = var.region
  dns_name                      = var.dns_name
  stack                         = var.stack
  stage_name                    = var.stage_name
  base_path                     = var.base_path
  aws_api_gateway_websocket_api = "oak9-${var.environment}-WebsocketOrchestrator"
  lambda_details                = module.Lambda.functions_details
  acm_certificate_arn           = data.aws_acm_certificate.oak9CloudOhio.arn
}

module "Buckets" {
  providers = {
    aws        = aws,
    aws.backup = aws.backup
  }
  source        = "../../_modules/Buckets"
  region        = var.region
  environment   = var.environment
  url           = "console.${var.dns_name}"
  s3Bucket      = "oak9-${var.stack}-deployment-assets"
  force_destroy = true
}

module "ArtifactBucket" {
  source        = "../../_modules/s3"
  bucket_name   = "oak9-plugin-artifacts"
  force_destroy = true
}

module "CloudFront" {
  source              = "../../_modules/CloudFront"
  region              = var.region
  dns_name            = var.dns_name
  environment         = var.environment
  ui_s3Bucket         = "${var.environment}console.${var.dns_name}.${var.region}-ui-assets"
  root_object_path    = "/ui-deployment"
  acm_certificate_arn = data.aws_acm_certificate.oak9CloudVirginia.arn
}

module "CloudFrontAzure" {
  source              = "../../_modules/CloudFrontAzure"
  region              = var.region
  dns_name            = var.dns_name
  environment         = var.environment
  ui_s3Bucket         = "${var.environment}-marketplace.${var.dns_name}.${var.region}-azure-ui-assets"
  root_object_path    = "/ui-deployment"
  acm_certificate_arn = data.aws_acm_certificate.oak9CloudVirginia.arn
}

module "DynamoDB" {
  source       = "../../_modules/DynamoDB"
  region       = var.region
  environment  = var.environment
  enable_POITB = false
}

module "Fargate" {
  source                        = "../../_modules/Fargate"
  region                        = var.region
  stack                         = var.stack
  neptune_endpoint              = module.Neptune.neptune_endpoint
  project_name                  = "oak9"
  ecr_repository_name           = "oak9-${var.stack}-ecr"
  link_aws_api_gateway_vpc_link = "api-vpc-link-${var.stack}"
  max_instance                  = 6
  min_instance                  = 4
  task_cpu                      = var.task_cpu
  task_memory                   = var.task_memory
  container_cpu                 = var.container_cpu
  container_memory              = var.container_memory
}

module "Lambda" {
  source                  = "../../_modules/Lambda"
  depends_on              = [module.Buckets.assest_bucket]
  region                  = var.region
  environment             = var.environment
  s3Bucket                = "oak9-${var.stack}-deployment-assets"
  default_file_path       = "${path.root}/../../_modules/utils/aspnetcore.zip"
  neptune_reader_endpoint = module.Neptune.neptune_reader_endpoint
  neptune_endpoint        = module.Neptune.neptune_endpoint
  neptune_subnet_ids      = module.Neptune.neptune_subnet_ids
  neptune_sg_id           = module.Neptune.neptune_sg_id
  neptune_connector       = module.Neptune.neptune_connector
  vpc_id                  = module.Fargate.oak9-vpc-id
  oak9-pub-route-table    = module.Fargate.oak9-pub-route-table
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
  url       = "${var.environment}console.${var.dns_name}"
  type      = "CNAME"
  value     = [module.CloudFront.cloudfront_details.domain_name]
  stack     = var.stack
}

module "DNS_apigateway" {
  providers = { aws = aws.production }
  source    = "../../_modules/Route53"
  url       = "${var.environment}api.${var.dns_name}"
  type      = "CNAME"
  value     = [module.ApiGateway.apigateway_domain_name]
  stack     = var.stack
}

module "DNS_apigateway_websocket" {
  providers = { aws = aws.production }
  source    = "../../_modules/Route53"
  url       = "${var.environment}ws-api.${var.dns_name}"
  type      = "CNAME"
  value     = [module.Websocket.apigateway_domain_name]
  stack     = var.stack
}

module "Cloudtrail" {
  source                = "../../_modules/CloudTrail"
  s3_bucket_name        = "oak9-security-cloudtrail"
  log_group_environment = var.environment
}

module "waf" {
  source      = "../../_modules/waf"
  console_arn = module.ApiGateway.apigateway_stage_arn
}


module "Neptune" {
  source               = "../../_modules/Neptune"
  neptune_size         = var.neptune_size
  environment          = var.environment
  vpc_id               = module.Fargate.oak9-vpc-id
  oak9-pub-route-table = module.Fargate.oak9-pub-route-table
}

module "cloudwatch" {
  source               = "../../_modules/cloudwatch"
  sns_cloudwatch_topic = module.Sns.sns_cloudwatch_topic
  api_name             = module.ApiGateway.apigateway_name
  lambda_details       = module.Lambda.functions_details
  environment          = var.environment
}

module "Oak9CodeArtifactDomain" {
  source      = "../../_modules/CodeArtifact/domain"
  domain_name = var.code_artifact_domain_name
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "GameScores"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UserId"
  range_key      = "GameTitle"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "GameTitle"
    type = "S"
  }

  attribute {
    name = "TopScore"
    type = "N"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  global_secondary_index {
    name               = "GameTitleIndex"
    hash_key           = "GameTitle"
    range_key          = "TopScore"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["UserId"]
  }

  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}

module "ConsoleCodeArtifactRepository" {
  source          = "../../_modules/CodeArtifact/repository"
  repository_name = "console-${var.region}"
  domain_name     = var.code_artifact_domain_name
  domain_owner    = module.Oak9CodeArtifactDomain.domain_owner
  description     = "By-product Repository for the oak9.console GitHub Repository"
}

module "ProtosCodeArtifactRepository" {
  source          = "../../_modules/CodeArtifact/repository"
  repository_name = "sac-protos-${var.region}"
  domain_name     = var.code_artifact_domain_name
  domain_owner    = module.Oak9CodeArtifactDomain.domain_owner
  description     = "The private repository for holding internal libraries relevant to Security-as-Code. This includes but is not limited to gRPC protobuf definition"
}

module "PypiInternal" {
  source                        = "../../_modules/CodeArtifact/repository_upstream"
  depends_on                    = [module.ProtosCodeArtifactRepository]
  repository_name               = "pypi-packages-${var.region}"
  domain_name                   = var.code_artifact_domain_name
  domain_owner                  = module.Oak9CodeArtifactDomain.domain_owner
  description                   = "Provides PyPI artifacts from upstream and external"
  upstream_sac_repo_name        = "sac-protos-${var.region}"
  upstream_pypi_repo_name       = "pypi-store"
  upstream_blueprints_repo_name = "sac-blueprints-${var.region}"
}

module "PublicPypi" {
  source                   = "../../_modules/CodeArtifact/repository_external"
  repository_name          = "pypi-store"
  domain_name              = var.code_artifact_domain_name
  domain_owner             = module.Oak9CodeArtifactDomain.domain_owner
  description              = "Provides PyPI artifacts from external"
  external_connection_name = "public:pypi"
}

module "DependencyFilterArtifactRepository" {
  source          = "../../_modules/CodeArtifact/repository"
  repository_name = "dependency-filter-${var.region}"
  domain_name     = var.code_artifact_domain_name
  domain_owner    = module.Oak9CodeArtifactDomain.domain_owner
  description     = "Depedency filter that accepts custom YAML filters for vulnerable dependency checks with JQ"
}

module "BlueprintsArtifactRepository" {
  source                  = "../../_modules/CodeArtifact/repository_upstream_blueprint"
  depends_on              = [module.PublicPypi]
  repository_name         = "sac-blueprints-${var.region}"
  domain_name             = var.code_artifact_domain_name
  domain_owner            = module.Oak9CodeArtifactDomain.domain_owner
  description             = "Security-as-code blueprints artifacts repo"
  upstream_pypi_repo_name = "pypi-store"
}

module "Ses" {
  source = "../../_modules/Ses"
}

module "Ecr" {
  source = "../../_modules/Ecr"
}

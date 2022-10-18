data "aws_iam_role" "oak9WriteCloudWatchLogs" {
  name = "oak9WriteCloudWatchLogs"
}

resource "aws_api_gateway_account" "oak9ApiGatewayLambdaAndConsole" {
  cloudwatch_role_arn = data.aws_iam_role.oak9WriteCloudWatchLogs.arn
}

resource "aws_api_gateway_rest_api" "oak9ApiGatewayLambdaAndConsole" {
  name        = var.aws_api_gateway_rest_api
  description = "API Gateway invoking consoleApi & lambda function"

  binary_media_types = [
    "multipart/form-data"
  ]

  endpoint_configuration {
    types = ["EDGE"]
  # oak9: aws_api_gateway_rest_api.endpoint_configuration.types has an edge optimised configuration for the API
  }
}

resource "aws_api_gateway_stage" "oak9ApiGatewayLambdaAndConsole" {
  # oak9: aws_api_gateway_stage.tags is not configured
  # oak9: aws_api_gateway_stage.access_log_settings is not configured
  deployment_id = aws_api_gateway_deployment.oak9ApiGatewayLambdaAndConsole.id
  rest_api_id   = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  stage_name    = var.stage_name
}

resource "aws_api_gateway_deployment" "oak9ApiGatewayLambdaAndConsole" {
  # oak9: aws_api_gateway_deployment.stage_description is not configured
  # oak9: api_gateway.deployment.stage_description.access_log_setting is not configured
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id

  depends_on = [
    aws_api_gateway_integration.proxy_cli_post,
    aws_api_gateway_integration.proxy_cli_get,
    aws_api_gateway_integration.proxy_console_any,
    aws_api_gateway_integration.proxy_console_options,
    aws_api_gateway_integration.proxy_integrations_any,
    aws_api_gateway_integration.proxy_integrations_options
  ]
  # stage_description = "Deployed at ${timestamp()}"
  # stage_name  = var.stage_name

  lifecycle {
    create_before_destroy = true
  }

  triggers = {
    deployed_at = "Deployed at ${timestamp()}"
  }
  
}

resource "aws_api_gateway_method_settings" "oak9GatewayStageLogging" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  stage_name  = aws_api_gateway_stage.oak9ApiGatewayLambdaAndConsole.stage_name
  method_path = "*/*"

  settings {
    caching_enabled    = false
    throttling_burst_limit = 5000
    throttling_rate_limit = 10000
    data_trace_enabled = true
    metrics_enabled    = false
    logging_level      = "ERROR"
    cache_data_encrypted = true
  }
}

resource "aws_api_gateway_domain_name" "customdomain" {
  # oak9: aws_api_gateway_domain_name.tags is not configured
  certificate_arn = var.acm_certificate_arn
  domain_name     = (var.stack == "prod" ? "api.${var.dns_name}": "${var.stack}api.${var.dns_name}")
  security_policy = "TLS_1_2"
}

resource "aws_api_gateway_base_path_mapping" "apimapping" {
  api_id      = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  domain_name = aws_api_gateway_domain_name.customdomain.domain_name
  stage_name  = aws_api_gateway_stage.oak9ApiGatewayLambdaAndConsole.stage_name
  base_path   = var.base_path
}
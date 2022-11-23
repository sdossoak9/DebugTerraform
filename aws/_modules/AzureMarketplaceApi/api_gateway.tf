data "aws_iam_role" "oak9WriteCloudWatchLogs" {
  name = "oak9WriteCloudWatchLogs"
}

resource "aws_api_gateway_account" "oak9ApiGatewayAzure" {
  cloudwatch_role_arn = data.aws_iam_role.oak9WriteCloudWatchLogs.arn
}

resource "aws_api_gateway_rest_api" "oak9ApiGatewayAzure" {
  name        = var.aws_api_gateway_rest_api
  description = "Azure Marketplace API Gateway"

  endpoint_configuration {
    types = ["EDGE"]
  # oak9: API GW rest apis configured as a non-private endpoint should have an attached resource policy
  }
}

resource "aws_api_gateway_domain_name" "customdomain" {
  certificate_arn = var.acm_certificate_arn
  domain_name     = (var.stack == "prod" ? "marketplace.${var.dns_name}": "${var.stack}marketplace.${var.dns_name}")
}

resource "aws_api_gateway_base_path_mapping" "apimapping" {
  api_id      = aws_api_gateway_rest_api.oak9ApiGatewayAzure.id
  domain_name = aws_api_gateway_domain_name.customdomain.domain_name
  stage_name  = var.stage_name
  base_path   = var.base_path
}


## Activate Subscription

resource "aws_lambda_permission" "activate_subscription" {
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = var.lambda_details.AzureMarketplaceActivate.function_name
  source_arn    = "${aws_api_gateway_rest_api.oak9ApiGatewayAzure.execution_arn}/*/POST/activate-subscription"
}

resource "aws_api_gateway_method" "activate_subscription" {
  rest_api_id   = aws_api_gateway_rest_api.oak9ApiGatewayAzure.id
  resource_id   = aws_api_gateway_resource.activate_subscription.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "activate_subscription" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayAzure.id
  resource_id = aws_api_gateway_resource.activate_subscription.id
  http_method = aws_api_gateway_method.activate_subscription.http_method
  status_code = "200"
}

resource "aws_api_gateway_resource" "activate_subscription" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayAzure.id
  parent_id   = aws_api_gateway_rest_api.oak9ApiGatewayAzure.root_resource_id
  path_part   = "activate-subscription"
}

resource "aws_api_gateway_integration" "activate_subscription" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayAzure.id
  resource_id = aws_api_gateway_resource.activate_subscription.id
  http_method = aws_api_gateway_method.activate_subscription.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri  = var.lambda_details.AzureMarketplaceActivate.invoke_arn
}

resource "aws_api_gateway_method" "activate_subscription_cors" {
  rest_api_id   = aws_api_gateway_rest_api.oak9ApiGatewayAzure.id
  resource_id   = aws_api_gateway_resource.activate_subscription.id
  http_method   = "OPTIONS"
  authorization = "NONE" # oak9: authorization should be set to any of aws_iam, custom, cognito_user_pools, none
}

resource "aws_api_gateway_method_response" "activate_subscription_cors" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayAzure.id
  resource_id = aws_api_gateway_resource.activate_subscription.id
  http_method = aws_api_gateway_method.activate_subscription_cors.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Methods"     = true
  }
}

resource "aws_api_gateway_integration" "activate_subscription_cors" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayAzure.id
  resource_id = aws_api_gateway_resource.activate_subscription.id
  http_method = aws_api_gateway_method.activate_subscription_cors.http_method
  type        = "MOCK"
  uri  = var.lambda_details.AzureMarketplaceActivate.invoke_arn
   request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "activate_subscription_cors" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayAzure.id
  resource_id = aws_api_gateway_resource.activate_subscription.id
  http_method = aws_api_gateway_method.activate_subscription_cors.http_method
  status_code = aws_api_gateway_method_response.activate_subscription_cors.status_code
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = "'*'"
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
  }
  response_templates = {
  "application/json" = "{}"
  }
}

## Webhook

resource "aws_lambda_permission" "webhook" {
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = var.lambda_details.AzureMarketplaceWebhooks.function_name
  source_arn    = "${aws_api_gateway_rest_api.oak9ApiGatewayAzure.execution_arn}/*/POST/webhook"
}

resource "aws_api_gateway_method" "webhook" {
  rest_api_id   = aws_api_gateway_rest_api.oak9ApiGatewayAzure.id
  resource_id   = aws_api_gateway_resource.webhook.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "webhook" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayAzure.id
  resource_id = aws_api_gateway_resource.webhook.id
  http_method = aws_api_gateway_method.webhook.http_method
  status_code = "200"
}

resource "aws_api_gateway_resource" "webhook" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayAzure.id
  parent_id   = aws_api_gateway_rest_api.oak9ApiGatewayAzure.root_resource_id
  path_part   = "webhook"
}

resource "aws_api_gateway_integration" "webhook" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayAzure.id
  resource_id = aws_api_gateway_resource.webhook.id
  http_method = aws_api_gateway_method.webhook.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri  = var.lambda_details.AzureMarketplaceWebhooks.invoke_arn
}

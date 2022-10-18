# Configuration for endpoints under integrations
resource "aws_api_gateway_resource" "integrations" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  parent_id   = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.root_resource_id
  path_part   = "integrations"
}

# Configuration for proxy endpoint under console path
resource "aws_api_gateway_resource" "proxy_integrations" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  parent_id   = aws_api_gateway_resource.integrations.id
  path_part   = "{proxy+}"
}

# Any endpoint under proxy integrations
resource "aws_api_gateway_method" "proxy_integrations_any" {
  rest_api_id   = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  resource_id   = aws_api_gateway_resource.proxy_integrations.id
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_method_response" "proxy_integrations_any" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  resource_id = aws_api_gateway_resource.proxy_integrations.id
  http_method = aws_api_gateway_method.proxy_integrations_any.http_method
  status_code = "200"

}

resource "aws_api_gateway_integration_response" "proxy_integrations_any" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  resource_id = aws_api_gateway_resource.proxy_integrations.id
  http_method = aws_api_gateway_method.proxy_integrations_any.http_method
  status_code = aws_api_gateway_method_response.proxy_console_any.status_code

  depends_on = [
    aws_api_gateway_integration.proxy_integrations_any
  ]
}

resource "aws_api_gateway_integration" "proxy_integrations_any" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  resource_id = aws_api_gateway_resource.proxy_integrations.id
  http_method = aws_api_gateway_method.proxy_integrations_any.http_method

  type                    = "HTTP_PROXY"
  uri                     = "http://api.endpoint.com/api/{proxy}"
  integration_http_method = "ANY"

  cache_key_parameters = [
    "method.request.path.proxy",
  ]

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }

  connection_type = "VPC_LINK"
  connection_id   = var.vpc_connection_id
}

# Options endpoint under proxy integrations
resource "aws_api_gateway_method" "proxy_integrations_options" {
  rest_api_id   = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  resource_id   = aws_api_gateway_resource.proxy_integrations.id
  http_method   = "OPTIONS"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_method_response" "proxy_integrations_options" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  resource_id = aws_api_gateway_resource.proxy_integrations.id
  http_method = aws_api_gateway_method.proxy_integrations_options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "proxy_integrations_options" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  resource_id = aws_api_gateway_resource.proxy_integrations.id
  http_method = aws_api_gateway_method.proxy_integrations_options.http_method
  status_code = aws_api_gateway_method_response.proxy_integrations_options.status_code

  depends_on = [ aws_api_gateway_integration.proxy_integrations_options ]
}

resource "aws_api_gateway_integration" "proxy_integrations_options" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  resource_id = aws_api_gateway_resource.proxy_integrations.id
  http_method = aws_api_gateway_method.proxy_integrations_options.http_method

  type                    = "HTTP_PROXY"
  uri                     = "http://api.endpoint.com/api/{proxy}"
  integration_http_method = "OPTIONS"
  timeout_milliseconds    = 29000

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }

  cache_key_parameters = ["integration.request.path.proxy"]
  connection_type      = "VPC_LINK"
  connection_id        = var.vpc_connection_id
}

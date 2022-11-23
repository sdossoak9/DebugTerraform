# Configuration for endpoints under console
resource "aws_api_gateway_resource" "console" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  parent_id   = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.root_resource_id
  path_part   = "console"
}

# Configuration for proxy endpoint under console path
resource "aws_api_gateway_resource" "proxy_console" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  parent_id   = aws_api_gateway_resource.console.id
  path_part   = "{proxy+}"
}

# Any endpoint under proxy console
resource "aws_api_gateway_method" "proxy_console_any" {
  rest_api_id   = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  resource_id   = aws_api_gateway_resource.proxy_console.id
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_method_response" "proxy_console_any" { # oak9:  should be set to any of aws_iam, custom, cognito_user_pools, none
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  resource_id = aws_api_gateway_resource.proxy_console.id
  http_method = aws_api_gateway_method.proxy_console_any.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "proxy_console_any" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  resource_id = aws_api_gateway_resource.proxy_console.id
  http_method = aws_api_gateway_method.proxy_console_any.http_method
  status_code = aws_api_gateway_method_response.proxy_console_any.status_code

  response_templates = {
    "application/json" = ""
  }

  depends_on = [
    aws_api_gateway_integration.proxy_console_any
  ]
}

resource "aws_api_gateway_integration" "proxy_console_any" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  resource_id = aws_api_gateway_resource.proxy_console.id
  http_method = aws_api_gateway_method.proxy_console_any.http_method

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

# Options endpoint under proxy console
resource "aws_api_gateway_method" "proxy_console_options" {
  rest_api_id   = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  resource_id   = aws_api_gateway_resource.proxy_console.id
  http_method   = "OPTIONS"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_method_response" "proxy_console_options" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  resource_id = aws_api_gateway_resource.proxy_console.id
  http_method = aws_api_gateway_method.proxy_console_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "proxy_console_options" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  resource_id = aws_api_gateway_resource.proxy_console.id
  http_method = aws_api_gateway_method.proxy_console_options.http_method
  status_code = aws_api_gateway_method_response.proxy_console_options.status_code

  response_templates = {
    "application/json" = ""
  }

  depends_on = [ aws_api_gateway_integration.proxy_console_options ]
}

resource "aws_api_gateway_integration" "proxy_console_options" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  resource_id = aws_api_gateway_resource.proxy_console.id
  http_method = aws_api_gateway_method.proxy_console_options.http_method

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

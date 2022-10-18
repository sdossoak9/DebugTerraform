
# Configuration for endpoints under cli
resource "aws_api_gateway_resource" "cli" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  parent_id   = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.root_resource_id
  path_part   = "cli"
}

# Configuration for proxy endpoint under cli path
resource "aws_api_gateway_resource" "proxy_cli" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  parent_id   = aws_api_gateway_resource.cli.id
  path_part   = "{proxy+}"
}

# Get endpoint under proxy cli
resource "aws_api_gateway_method" "proxy_cli_get" {
  rest_api_id   = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  resource_id   = aws_api_gateway_resource.proxy_cli.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_method_response" "proxy_cli_get" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  resource_id = aws_api_gateway_resource.proxy_cli.id
  http_method = aws_api_gateway_method.proxy_cli_get.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
  depends_on = [
    aws_api_gateway_integration.proxy_cli_get
  ]
}

resource "aws_api_gateway_integration_response" "proxy_cli_get" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  resource_id = aws_api_gateway_resource.proxy_cli.id
  http_method = aws_api_gateway_method.proxy_cli_get.http_method
  status_code = aws_api_gateway_method_response.proxy_cli_get.status_code

  response_templates = {
    "application/json" = ""
  }
}


resource "aws_api_gateway_integration" "proxy_cli_get" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  resource_id = aws_api_gateway_resource.proxy_cli.id
  http_method = aws_api_gateway_method.proxy_cli_get.http_method

  type                    = "HTTP_PROXY"
  uri                     = "http://api.endpoint.com/api/{proxy}"
  integration_http_method = "GET"
  timeout_milliseconds    = 29000

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }

  connection_type = "VPC_LINK"
  connection_id   = var.vpc_connection_id
}

# Post endpoint under proxy cli
resource "aws_api_gateway_method" "proxy_cli_post" {
  rest_api_id   = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  resource_id   = aws_api_gateway_resource.proxy_cli.id
  http_method   = "POST"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_method_response" "proxy_cli_post" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  resource_id = aws_api_gateway_resource.proxy_cli.id
  http_method = aws_api_gateway_method.proxy_cli_post.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "proxy_cli_post" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  resource_id = aws_api_gateway_resource.proxy_cli.id
  http_method = aws_api_gateway_method.proxy_cli_post.http_method
  status_code = aws_api_gateway_method_response.proxy_cli_post.status_code

  response_templates = {
    "application/json" = ""
  }

  depends_on = [
    aws_api_gateway_integration.proxy_cli_post
  ]
}


resource "aws_api_gateway_integration" "proxy_cli_post" {
  rest_api_id = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.id
  resource_id = aws_api_gateway_resource.proxy_cli.id
  http_method = aws_api_gateway_method.proxy_cli_post.http_method

  type                    = "HTTP_PROXY"
  uri                     = "http://api.endpoint.com/api/{proxy}"
  integration_http_method = "POST"
  timeout_milliseconds    = 29000

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }

  connection_type = "VPC_LINK"
  connection_id   = var.vpc_connection_id

}

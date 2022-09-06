resource "aws_api_gateway_rest_api" "Oak9SampleAPIGateway" { # oak9: aws_api_gateway_rest_api.policy should be set to any of [isNotNullOrEmpty()]
  name        = var.apiGatewayName
  description = "API Gateway invoking Oak9SampleFunction lambda function"
}


resource "aws_api_gateway_resource" "proxy" {
   rest_api_id = aws_api_gateway_rest_api.Oak9SampleAPIGateway.id
   parent_id   = aws_api_gateway_rest_api.Oak9SampleAPIGateway.root_resource_id
   path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" { # oak9: aws_api_gateway_method.authorizer_id should be set to any of [isNotNullOrEmpty()]
   rest_api_id   = aws_api_gateway_rest_api.Oak9SampleAPIGateway.id
   resource_id   = aws_api_gateway_resource.proxy.id
   http_method   = "ANY"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
   rest_api_id = aws_api_gateway_rest_api.Oak9SampleAPIGateway.id
   resource_id = aws_api_gateway_method.proxy.resource_id
   http_method = aws_api_gateway_method.proxy.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.Oak9SampleFunction.invoke_arn
}

resource "aws_api_gateway_deployment" "Oak9SampleAPIGateway_deployment" { # oak9: aws_api_gateway_deployment.stage_description should be set to any of [isNotNullOrEmpty()]
   depends_on = [
     aws_api_gateway_integration.lambda,
     aws_api_gateway_integration.lambda_root,
   ]

   authorization = "None"
   rest_api_id = aws_api_gateway_rest_api.Oak9SampleAPIGateway.id
   stage_name  = var.apiGatewayStage
}
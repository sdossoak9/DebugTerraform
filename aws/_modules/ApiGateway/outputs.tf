output "apigateway_domain_name" {
  value = aws_api_gateway_domain_name.customdomain.cloudfront_domain_name
}

output "apigateway_stage_arn" {
  value = aws_api_gateway_stage.oak9ApiGatewayLambdaAndConsole.arn
}

output "apigateway_name" {
  value = aws_api_gateway_rest_api.oak9ApiGatewayLambdaAndConsole.name
}
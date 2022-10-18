data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "oak9ConsoleApiServiceTaskRole_arn" {
  description = "ARN of IAM role oak9ConsoleApiServiceTaskRole"
  value       = aws_iam_role.oak9ConsoleApiServiceTaskRole.arn
}

output "ecsTaskExecutionRole_arn" {
  description = "ARN of IAM role ecsTaskExecutionRole"
  value       = aws_iam_role.ecsTaskExecutionRole.arn
}

output "lambdaLoggingPolicy_arn" {
  description = "ARN lambda cloudwatch login policy"
  value       = aws_iam_policy.lambda_logging.arn
}

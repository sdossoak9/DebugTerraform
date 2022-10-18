resource "aws_cloudtrail" "securitytrail" {
  name                          = "oak9-management-events"
  s3_bucket_name                = var.s3_bucket_name
  include_global_service_events = true
  s3_key_prefix = "oak9ct"

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.default.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail.arn
  enable_log_file_validation = true
}

resource "aws_cloudwatch_log_group" "default" {
  name    = "cloudtrail-${var.log_group_environment}"
}

resource "aws_iam_role_policy" "couldtrail" {
  name = "cloudtrail-${var.log_group_environment}"
  role = aws_iam_role.cloudtrail.id

    policy = jsonencode({
      Version: "2012-10-17",
      Statement: [
        {
          Effect: "Allow",
          Action: [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          Resource: "arn:aws:logs:*:*:*"
        }
      ]
    })
}

resource "aws_iam_role" "cloudtrail" {
  name = "cloudtrail-${var.log_group_environment}-role"

  assume_role_policy = jsonencode({
    Version: "2012-10-17"
    Statement: [
      {
        Effect: "Allow",
        Principal: {
          Service: "cloudtrail.amazonaws.com"
        },
        Action: "sts:AssumeRole"
      }
    ]
  }) 
}

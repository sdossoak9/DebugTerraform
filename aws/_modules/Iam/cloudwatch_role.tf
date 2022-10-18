resource "aws_iam_role" "oak9WriteCloudWatchLogs" {
  name = "oak9WriteCloudWatchLogs"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "apigateway.amazonaws.com",
            "lambda.amazonaws.com"
          ]
        },
        "Action" : [
          "sts:AssumeRole",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "oak9WriteCloudWatchLogs" {
  role       = aws_iam_role.oak9WriteCloudWatchLogs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

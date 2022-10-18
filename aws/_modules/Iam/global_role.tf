resource "aws_iam_role" "validateEngine" {
  name = "validateEngine"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" :[
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "lambda.amazonaws.com",
            "ecs-tasks.amazonaws.com"
          ]
        },
        "Action" : [
          "sts:AssumeRole"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "validateEngine_lambda" {
  role       = aws_iam_role.validateEngine.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_role_policy_attachment" "validateEngine_secretManager" {
  role       = aws_iam_role.validateEngine.name
  policy_arn = aws_iam_policy.oak9SecretsManagerRead.arn
}

resource "aws_iam_role_policy_attachment" "validateEngine_SNS" {
  role       = aws_iam_role.validateEngine.name
  policy_arn = aws_iam_policy.oak9SnsPublish.arn
}

resource "aws_iam_role_policy_attachment" "validateEngine_dynamoDB" {
  role       = aws_iam_role.validateEngine.name
  policy_arn = aws_iam_policy.oak9DynamoDbReadWrite.arn
}

resource "aws_iam_role_policy_attachment" "validateEngine_s3" {
  role       = aws_iam_role.validateEngine.name
  policy_arn = aws_iam_policy.oak9S3BucketReadWrite.arn
}

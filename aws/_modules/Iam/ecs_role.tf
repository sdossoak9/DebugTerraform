data "aws_ssm_parameter" "eks_oidc" {
  name = "/terraform/eks_cloud_oidc"
}

resource "aws_iam_role" "oak9ConsoleApiServiceTaskRole" {
  name = "oak9ConsoleApiServiceTaskRole"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
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
      },
      {
          "Effect": "Allow",
          "Principal": {
              "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${data.aws_ssm_parameter.eks_oidc.value}"
          },
          "Action": "sts:AssumeRoleWithWebIdentity",
          "Condition": {
              "StringEquals": {
                   "${data.aws_ssm_parameter.eks_oidc.value}:aud": "sts.amazonaws.com",
                   "${data.aws_ssm_parameter.eks_oidc.value}:sub": "system:serviceaccount:coreapi:consoleapi-service-account"
              }
          }
      }
   ]
  })
}

resource "aws_iam_role_policy_attachment" "oak9SnsPublish" {
  role       = aws_iam_role.oak9ConsoleApiServiceTaskRole.name
  policy_arn = aws_iam_policy.oak9SnsPublish.arn
}

resource "aws_iam_role_policy_attachment" "oak9SecretsManagerPut" {
  role       = aws_iam_role.oak9ConsoleApiServiceTaskRole.name
  policy_arn = aws_iam_policy.oak9SecretsManagerPut.arn
}

resource "aws_iam_role_policy_attachment" "oak9DynamoDbReadWrite" {
  role       = aws_iam_role.oak9ConsoleApiServiceTaskRole.name
  policy_arn = aws_iam_policy.oak9DynamoDbReadWrite.arn
}

resource "aws_iam_role_policy_attachment" "oak9S3BucketReadWrite" {
  role       = aws_iam_role.oak9ConsoleApiServiceTaskRole.name
  policy_arn = aws_iam_policy.oak9S3BucketReadWrite.arn
}

resource "aws_iam_role_policy_attachment" "oak9SecretsManagerRead" {
  role       = aws_iam_role.oak9ConsoleApiServiceTaskRole.name
  policy_arn = aws_iam_policy.oak9SecretsManagerRead.arn
}

resource "aws_iam_role_policy_attachment" "oak9EcsAutoscale" {
  role       = aws_iam_role.oak9ConsoleApiServiceTaskRole.name
  policy_arn = aws_iam_policy.oak9EcsAutoscale.arn
}

resource "aws_iam_role_policy_attachment" "Oak9SendEmail" {
  role       = aws_iam_role.oak9ConsoleApiServiceTaskRole.name
  policy_arn = aws_iam_policy.Oak9SendEmail.arn
}

data "aws_iam_policy_document" "ecsTaskExecutionRole" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecsTaskExecutionRole.json
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

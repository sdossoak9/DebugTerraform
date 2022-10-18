resource "aws_iam_policy" "oak9SnsPublish" {
  name = "oak9SnsPublish"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "sns:Publish",
          "sns:ListTopics"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy" "Oak9SNSReadPublish" {
  name = "Oak9SNSReadPublish"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "sns:ListEndpointsByPlatformApplication",
          "sns:ListSubscriptionsByTopic",
          "sns:Publish",
          "sns:GetTopicAttributes",
          "sns:ListTopics",
          "sns:GetSubscriptionAttributes",
          "sns:ListSubscriptions",
          "sns:ListPlatformApplications"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy" "Oak9SendEmail" {
  name = "Oak9SendEmail"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "VisualEditor0",
        "Effect": "Allow",
        "Action": [
            "ses:SendEmail",
            "ses:SendTemplatedEmail",
            "ses:SendCustomVerificationEmail",
            "ses:SendRawEmail",
            "ses:SendBulkTemplatedEmail",
            "ses:SendBounce"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_policy" "oak9SecretsManagerPut" {
  name = "oak9SecretsManagerPut"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:PutSecretValue",
          "secretsmanager:CreateSecret",
          "secretsmanager:UpdateSecret"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy" "oak9SecretsManagerRead" {
  name = "oak9SecretsManagerRead"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy" "oak9SecretsManagerDelete" {
  name = "oak9SecretsManagerDelete"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:ListSecrets",
          "secretsmanager:DeleteSecret"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy" "oak9DynamoDbReadWrite" {
  name = "oak9DynamoDbReadWrite"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:BatchGetItem",
          "dynamodb:PutItem",
          "dynamodb:DescribeTable",
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:ListTagsOfResource",
          "dynamodb:UpdateItem",
          "dynamodb:UpdateTable",
          "dynamodb:UpdateTimeToLive",
          "dynamodb:ListTables",
          "dynamodb:ListStreams",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:GetRecords"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy" "oak9S3BucketReadWrite" {
  name = "oak9S3BucketReadWrite"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutAccelerateConfiguration",
          "s3:GetObjectVersionTagging",
          "s3:ListBucketVersions",
          "s3:GetBucketLogging",
          "s3:ListBucket",
          "s3:GetObjectVersionTorrent",
          "s3:GetObjectAcl",
          "s3:AbortMultipartUpload",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectTagging",
          "s3:PutBucketVersioning",
          "s3:ListBucketMultipartUploads",
          "s3:GetObjectRetention",
          "s3:ListJobs",
          "s3:PutObjectLegalHold",
          "s3:PutBucketCORS",
          "s3:GetBucketAcl",
          "s3:ListMultipartUploadParts",
          "s3:ListStorageLensConfigurations",
          "s3:PutObject",
          "s3:PutObjectTagging",
          "s3:GetObject",
          "s3:PutBucketNotification",
          "s3:GetObjectTorrent",
          "s3:PutBucketWebsite",
          "s3:ListAllMyBuckets",
          "s3:PutBucketLogging",
          "s3:PutBucketObjectLockConfiguration",
          "s3:GetObjectVersionForReplication",
          "s3:GetBucketLocation",
          "s3:GetObjectVersion"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy" "oak9S3ObjectDelete" {
  name = "oak9S3ObjectDelete"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:DeleteObject"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy" "oak9EcsLoadbalancer" {
  name = "oak9EcsLoadbalancer"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:Describe*",
          "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:Describe*",
          "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
          "elasticloadbalancing:RegisterTargets"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy" "oak9EcsAutoscale" {
  name = "oak9EcsAutoscale"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "application-autoscaling:*",
            "ecs:DescribeServices",
            "ecs:UpdateService",
            "cloudwatch:DescribeAlarms",
            "cloudwatch:PutMetricAlarm",
            "cloudwatch:DeleteAlarms",
            "cloudwatch:DescribeAlarmHistory",
            "cloudwatch:DescribeAlarmsForMetric",
            "cloudwatch:GetMetricStatistics",
            "cloudwatch:ListMetrics",
            "cloudwatch:DisableAlarmActions",
            "cloudwatch:EnableAlarmActions",
            "iam:CreateServiceLinkedRole",
            "sns:CreateTopic",
            "sns:Subscribe",
            "sns:Get*",
            "sns:List*"
          ],
          "Resource" : [
            "*"
          ]
        }
      ]
    }
  )
}

data "aws_iam_policy_document" "oak9WsManageConnections" {
  statement {
    effect = "Allow"
    
    actions = [
        "execute-api:*",
      ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "oak9WsManageConnections" {
  name = "oak9WsManageConnections"
  policy = data.aws_iam_policy_document.oak9WsManageConnections.json

}


data "aws_iam_policy_document" "oak9CreateTerraformRequestReceivedTopic" {
  statement {
      sid = "VisualEditor0"
      effect= "Allow"
      actions = [
          "sns:CreateTopic",
        ]
      resources = [
        "arn:aws:sns:*:*:TerraformRequestReceived",
      ]
  }
}

resource "aws_iam_policy" "oak9CreateTerraformRequestReceivedTopic" {
  name = "oak9CreateTerraformRequestReceivedTopic"
  policy = data.aws_iam_policy_document.oak9CreateTerraformRequestReceivedTopic.json
}

data "aws_iam_policy_document" "oak9CreateRemediationUploadedTopic" {
  statement {
      sid = "VisualEditor0"
      effect= "Allow"
      actions = [
          "sns:CreateTopic",
        ]
      resources = [
        "arn:aws:sns:*:*:RemediationUploaded",
      ]
  }
}

resource "aws_iam_policy" "oak9CreateRemediationUploadedTopic" {
  name = "oak9CreateRemediationUploadedTopic"
  policy = data.aws_iam_policy_document.oak9CreateRemediationUploadedTopic.json
}

data "aws_iam_policy_document" "oak9CreateTriggerRepositoryRemediationTopic" {
  statement {
      sid = "VisualEditor0"
      effect= "Allow"
      actions = [
          "sns:CreateTopic",
        ]
      resources = [
        "arn:aws:sns:*:*:RemediationUploaded",
      ]
  }
}

resource "aws_iam_policy" "oak9CreateTriggerRepositoryRemediationTopic" {
  name = "oak9CreateTriggerRepositoryRemediationTopic"
  policy = data.aws_iam_policy_document.oak9CreateTriggerRepositoryRemediationTopic.json
}

resource "aws_iam_policy" "oak9LambdaInvoke" {
  name = "oak9LambdaInvoke"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction",
                "lambda:InvokeAsync"
            ],
            "Resource": "*"
        }
    ]
  })
}

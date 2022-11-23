data "aws_caller_identity" "current" {}

data "aws_partition" "current" {
}

locals {
  partition  = data.aws_partition.current.partition
}


resource "aws_cloudtrail" "securitytrail" {
  # oak9: aws_cloudtrail.enable_logging is not set to 
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_cloudwatch_events_role.arn
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cwl_loggroup.arn}:*"
  name                          = "oak9-management-events"
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  include_global_service_events = true
  enable_log_file_validation = true
  s3_key_prefix = "oak9ct"
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket        = "oak9-security-cloudtrail"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::oak9-security-cloudtrail"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": [
                "arn:aws:s3:::oak9-security-cloudtrail/oak9ct/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
                "arn:aws:s3:::oak9-security-cloudtrail/oak9ct/AWSLogs/811392992219/*",
                "arn:aws:s3:::oak9-security-cloudtrail/oak9ct/AWSLogs/164810006412/*",
                "arn:aws:s3:::oak9-security-cloudtrail/oak9ct/AWSLogs/570617910004/*"
            ],
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_s3_bucket_public_access_block" "security" {
  bucket                  = aws_s3_bucket.cloudtrail.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_iam_role" "cloudtrail_cloudwatch_events_role" {
  name_prefix        = "cloudtrail_events_role"
  path               = var.iam_path
  assume_role_policy = data.aws_iam_policy_document.cwl_assume_policy.json
  tags               = var.tags
}

resource "aws_iam_role_policy" "cwl_policy" {
  name_prefix = "cloudtrail_cloudwatch_events_policy"
  role        = aws_iam_role.cloudtrail_cloudwatch_events_role.id
  policy      = data.aws_iam_policy_document.cwl_policy.json
}

data "aws_iam_policy_document" "cwl_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cwl_policy" {
  statement {
    effect  = "Allow"
    actions = ["logs:CreateLogStream"]

    resources = [
      "arn:${local.partition}:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.cwl_loggroup.name}:log-stream:*",
    ]
  }

  statement {
    effect  = "Allow"
    actions = ["logs:PutLogEvents"]

    resources = [
      "arn:${local.partition}:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.cwl_loggroup.name}:log-stream:*",
    ]
  }
}

resource "aws_cloudwatch_log_group" "cwl_loggroup" {
  name              = var.log_group_name
  retention_in_days = var.retention_in_days == -1 ? null : var.retention_in_days
  tags              = var.tags
}

resource "aws_cloudwatch_log_stream" "cwl_stream" {
  name           = data.aws_caller_identity.current.account_id
  log_group_name = aws_cloudwatch_log_group.cwl_loggroup.name
}
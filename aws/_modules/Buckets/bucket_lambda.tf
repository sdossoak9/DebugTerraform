resource "aws_s3_bucket" "lambda" {
  # oak9: s3.bucket.lifecycle_configuration.rules is not configured
  bucket        = var.s3Bucket
  # oak9: aws_s3_bucket.logging.target_bucket is not configured
  force_destroy = var.force_destroy

  tags = {
    Name        = var.s3Bucket
    Environment = var.environment
  }
}

resource "aws_s3_bucket_acl" "lambda" {
  bucket = aws_s3_bucket.lambda.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "lambda" {
  bucket   = aws_s3_bucket.lambda.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lambda" {
  bucket = aws_s3_bucket.lambda.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "lambda_bucket" {
  count                   = var.disable_public_access ? 1 : 0
  bucket                  = aws_s3_bucket.lambda.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

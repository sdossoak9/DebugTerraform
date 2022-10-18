resource "aws_s3_bucket" "iac-remediation" {
  # oak9: aws_s3_bucket.tags is not configured
  bucket = "${var.environment}${var.url}.${var.region}-iac-remediation"
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_acl" "iac-remediation" {
  bucket = aws_s3_bucket.iac-remediation.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "iac-remediation" {
  bucket   = aws_s3_bucket.iac-remediation.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "iac-remediation" {
  bucket = aws_s3_bucket.iac-remediation.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "iac-remediation" {
  bucket                  = aws_s3_bucket.iac-remediation.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

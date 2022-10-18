resource "aws_s3_bucket" "iac-remediation" {
  bucket = "${var.environment}${var.url}.${var.region}-iac-remediation"
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_acl" "iac-remediation" {
  bucket = aws_s3_bucket.iac-remediation.id
  acl    = "private" # oak9: acl should be set to any of publicread, publicreadwrite, authenticateread
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
      sse_algorithm = "AES256" # oak9: rule.apply_server_side_encryption_by_default.sse_algorithm should be set to any of aws:kms
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

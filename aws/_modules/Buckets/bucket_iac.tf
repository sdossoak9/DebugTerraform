resource "aws_s3_bucket" "iac" {
  # oak9: s3.bucket.lifecycle_configuration.rules is not configured
  bucket        = "${var.environment}${var.url}.${var.region}-iac"
  # oak9: aws_s3_bucket.logging.target_bucket is not configured
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_acl" "iac" {
  bucket = aws_s3_bucket.iac.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "iac" {
  bucket   = aws_s3_bucket.iac.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "iac" {
  bucket = aws_s3_bucket.iac.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "iac" {
  bucket                  = aws_s3_bucket.iac.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

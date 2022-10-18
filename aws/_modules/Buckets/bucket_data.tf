resource "aws_s3_bucket" "data" {
  # oak9: aws_s3_bucket_cors_configuration.cors_rule is not configured
  bucket        = "${var.environment}${var.url}.${var.region}-data"
  force_destroy = var.force_destroy

  lifecycle_rule {
    id = "ScanResourceFragment-Cleanup"
    enabled = true

    tags = {
      ScanResourceFragmentDeletionMarker = "true"
    }    

    expiration {
      days = 1
    }
  }
}

resource "aws_s3_bucket_acl" "data" {
  bucket = aws_s3_bucket.data.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "data" {
  bucket   = aws_s3_bucket.data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data" {
  bucket = aws_s3_bucket.data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "data" {
  bucket                  = aws_s3_bucket.data.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

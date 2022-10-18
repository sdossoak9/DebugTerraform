resource "aws_s3_bucket" "client-resources" {
  # oak9: aws_s3_bucket.tags is not configured
  bucket        = "${var.environment}${var.url}.${var.region}-client-resources"
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_acl" "client-resources" {
  bucket = aws_s3_bucket.client-resources.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "client-resources" {
  bucket   = aws_s3_bucket.client-resources.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "client-resources" {
  bucket = aws_s3_bucket.client-resources.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "client-resources" {
  bucket                  = aws_s3_bucket.client-resources.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

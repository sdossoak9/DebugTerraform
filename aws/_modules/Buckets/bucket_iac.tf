resource "aws_s3_bucket" "iac" {
  bucket        = "${var.environment}${var.url}.${var.region}-iac"
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
      sse_algorithm = "AES256" # oak9: rule.apply_server_side_encryption_by_default.sse_algorithm should be set to any of aws:kms
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

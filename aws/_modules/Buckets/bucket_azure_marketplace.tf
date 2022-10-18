resource "aws_s3_bucket" "azure_marketplace" {
  bucket        = "${var.environment}${var.url}.${var.region}-azure-marketplace"
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_acl" "azure_marketplace" {
  bucket = aws_s3_bucket.azure_marketplace.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "azure_marketplace" {
  bucket   = aws_s3_bucket.azure_marketplace.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "azure_marketplace" {
  bucket = aws_s3_bucket.azure_marketplace.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # oak9: rule.apply_server_side_encryption_by_default.sse_algorithm should be set to any of aws:kms
    }
  }
}

resource "aws_s3_bucket_public_access_block" "azure_marketplace" {
  bucket                  = aws_s3_bucket.azure_marketplace.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

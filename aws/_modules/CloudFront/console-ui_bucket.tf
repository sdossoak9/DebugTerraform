resource "aws_s3_bucket" "console_ui_bucket" {
  bucket = var.ui_s3Bucket
  # oak9: aws_s3_bucket.logging.target_bucket is not configured
  force_destroy = true

  tags = {
    Name        = var.ui_s3Bucket
    environment = var.environment
    org         = var.organisation
    app         = var.application
  }
}

resource "aws_s3_bucket_logging" "console_ui_bucket" {
  count = var.environment == "" ? 1 : 0

  bucket = var.ui_s3Bucket
  target_bucket = "oak9-s3-server-access"
  target_prefix = "s3-server-access/"
}

resource "aws_s3_bucket_acl" "console_ui_bucket" {
  bucket = aws_s3_bucket.console_ui_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "console_ui_bucket" {
  bucket = aws_s3_bucket.console_ui_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_cors_configuration" "console_ui_bucket" {
  bucket = aws_s3_bucket.console_ui_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = var.environment == "" ? ["https://oak9app.b2clogin.com"] : ["https://oak9${var.environment}.b2clogin.com"]
    expose_headers = []
  }
  
}

resource "aws_s3_bucket_public_access_block" "console_ui_bucket" {
  count                   = var.enable_public_access_block ? 1 : 0
  bucket                  = aws_s3_bucket.console_ui_bucket.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

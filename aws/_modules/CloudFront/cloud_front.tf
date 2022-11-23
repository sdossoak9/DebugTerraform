resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "${var.environment} CF access identity"
}

locals {
  s3_origin_id = "${var.ui_s3Bucket}Origin"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  # oak9: aws_cloudfront_distribution.default_cache_behavior.trusted_signers is not configured
  origin {
    domain_name = aws_s3_bucket.console_ui_bucket.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
    origin_path = var.root_object_path

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  aliases = ["${var.environment}console.${var.dns_name}"]

  enabled             = true
  is_ipv6_enabled     = true
  comment             = " "
  default_root_object = ""

  # ordered_cache_behavior {
  #   allowed_methods  = ["GET", "HEAD"]
  #   cached_methods   = ["GET", "HEAD"]
  #   compress         = true
  #   target_origin_id = local.s3_origin_id
  #   viewer_protocol_policy = "redirect-to-https"
  #   path_pattern = "/*"
  # }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "whitelist"
        whitelisted_names = [
          "Origin",
          "Authorization",
          "Access-Control-Request-Headers",
          "Access-Control-Request-Method"
        ]
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    error_caching_min_ttl = 300
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    error_caching_min_ttl = 300
    response_page_path    = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      locations        = ["CN","TW","RU","KR"]
    }
  }

  tags = {
    Environment = var.environment
    User        = "jenkins"
  }

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = var.acm_certificate_arn == "" ? "" : "sni-only"
    # oak9: aws_cloudfront_distribution.viewer_certificate.ssl_support_method is not configured
    minimum_protocol_version       = var.minimum_protocol_version
    cloudfront_default_certificate = var.acm_certificate_arn == "" ? true : false
  }

}

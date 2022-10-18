resource "aws_s3_bucket_policy" "console_ui_bucket" {
  bucket = aws_s3_bucket.console_ui_bucket.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "PolicyForCloudFrontPrivateContent",
    "Statement" : [
      {
        "Sid" : "1",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.origin_access_identity.id}"
        },
        "Action" : "s3:GetObject",
        "Resource" : "${aws_s3_bucket.console_ui_bucket.arn}/*"
      }
    ]
  })
}

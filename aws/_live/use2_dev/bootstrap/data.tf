data "aws_acm_certificate" "oak9Cloud" {
  domain   = "*.oak9.cloud"
  statuses = ["ISSUED"]
}

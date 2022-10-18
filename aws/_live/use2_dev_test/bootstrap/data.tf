data "aws_ssm_parameter" "kibana_pass" {
  name = "kibana_pass"
  depends_on = [ module.Ssm ]
}

data "aws_acm_certificate" "oak9Cloud" {
  domain   = "*.oak9.cloud"
  statuses = ["ISSUED"]
}
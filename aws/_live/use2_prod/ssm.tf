data "aws_route_table" "oak9-default-route-table" {
  vpc_id = module.Fargate.oak9-vpc-id

  filter {
    name   = "association.main"
    values = ["true*"]
  }
}


module "store_write" {
  source  = "cloudposse/ssm-parameter-store/aws"
  version = "0.8.5"
  parameter_write = [
    {
      name        = "${var.ssm-path}/oak9-vpc-id"
      value       = module.Fargate.oak9-vpc-id
      type        = "String"
      overwrite   = "true"
      description = "oak9 VPC ID"
    },
    {
      name        = "${var.ssm-path}/oak9-vpc-cidr"
      value       = module.Fargate.oak9-vpc-cidr
      type        = "String"
      overwrite   = "true"
      description = "oak9 VPC CIDR Block"
    },
    {
      name        = "${var.ssm-path}/oak9-default-rt-id"
      value       = data.aws_route_table.oak9-default-route-table.id
      type        = "String"
      overwrite   = "true"
      description = "oak9 Default Route Table ID"
    },
    {
      name        = "${var.ssm-path}/acm_certificate_arn"
      value       = data.aws_acm_certificate.oak9Cloud.arn
      type        = "String"
      overwrite   = "true"
      description = "US-East-2 ACM Cert"
    },
    {
      name        = "${var.ssm-path}/neptune_endpoint"
      value       = module.Neptune.neptune_endpoint
      type        = "String"
      overwrite   = "true"
      description = "Neptune Endpoint"
    }
  ]

  tags = {
    ManagedBy = "Terraform"
  }
}

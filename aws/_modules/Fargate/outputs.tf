data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "vpc_connection_id" {
  value = aws_api_gateway_vpc_link.api-oak9.id
}

output "oak9-vpc-id" {
  value = aws_vpc.oak9-vpc.id
}

output "oak9-vpc-cidr" {
  value = aws_vpc.oak9-vpc.cidr_block 
}


output "oak9-pub-route-table" {
  value = aws_route_table.oak9-public.id
}

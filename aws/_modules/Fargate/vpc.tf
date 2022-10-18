data "aws_lb" "k8s_consoleapi" {
  name = "k8s-consoleapi-nlb"
}

resource "aws_vpc" "oak9-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name
  enable_classiclink   = "false"
  instance_tenancy     = "default"

  tags = {
    Name = "${var.project_name}-${var.stack}-vpc"
  }
}

resource "aws_internet_gateway" "oak9-igw" {
  vpc_id = aws_vpc.oak9-vpc.id
  tags = {
    Name = "${var.project_name}-${var.stack}-igw"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.oak9-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true" //it makes this a public subnet
  # availability_zone = "${var.region}a"
  tags = {
    Name = "${var.project_name}-${var.stack}-public"
  }
}

resource "aws_route_table" "oak9-public" {
  vpc_id = aws_vpc.oak9-vpc.id
  route {
    //associated subnet can reach everywhere
    //CRT uses this IGW to reach internet
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.oak9-igw.id
  }
  tags = {
    Name = "${var.project_name}-${var.stack}-public-crt"
  }
}

resource "aws_route_table_association" "oak9-public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.oak9-public.id
}

resource "aws_eip" "nat_gateway" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public.id
  tags = {
    "Name" = "${var.project_name}-${var.stack}-public-natgateway"
  }
}

resource "aws_api_gateway_vpc_link" "api-oak9" {
  name        = var.link_aws_api_gateway_vpc_link
  description = "connection of VPC link"
  #target_arns = [aws_lb.ConsoleApi.arn]
  target_arns = ["${data.aws_lb.k8s_consoleapi.arn}"]
}

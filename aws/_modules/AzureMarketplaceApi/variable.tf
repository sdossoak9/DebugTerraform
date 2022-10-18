variable "region" {
  type    = string
  default = "us-east-1"
}

variable "stack" {
  type    = string
  default = ""
}

variable "base_path" {
  type    = string
  default = ""
}

variable "dns_name" {
  type    = string
  default = ""
}

variable "s3Bucket" {
  type    = string
  default = "lambda-code"
}

variable "vpc_connection_id" {
  type    = string
  default = ""
}

variable "aws_api_gateway_rest_api" {
  type    = string
  default = "oak9.api.gateway.lambda"
}

variable "lambda_details" {
  type = map(any)
  default = {
    "AzureMarketplaceActivate" : "",
    "AzureMarketplaceWebhooks": "",
  }
}

variable "acm_certificate_arn" {
  type    = string
  default = ""
}

variable "stage_name" {
  type    = string
  default = ""
}

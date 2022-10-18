variable "region" {
  type    = string
  default = "us-east-1"
}

variable "enable_public_access_block" {
  type    = bool
  default = true
}

variable "stack" {
  type    = string
  default = ""
}

variable "stage_name" {
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

variable "app_version" {
  type    = string
  default = "v1"
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
    "ApplyFixes" : "",
    "CloudResourceMonitor" : "",
    "DashboardComputation" : "",
    "HybridAuthorizer" : "",
    "NotificationService" : "",
    "PaymentEvent": "",
    "PaymentDowngradeScheduler": "",
    "PaymentDowngradeEnforcer": "",
    "PolicyExceptions" : "",
    "repositoryListener" : "",
    "ResourceProvider" : "",
    "TaskWorkflow" : "",
    "WatchScan" : ""
  }
}

variable "acm_certificate_arn" {
  type    = string
  default = ""
}

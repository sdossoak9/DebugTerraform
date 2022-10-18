variable "region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "enable_POITB" {
  type    = bool
  default = false
}

variable "basic-table-1_aws_dynamodb_table" {
  type    = string
  default = "oak9.blueprints.catalog"
}

variable "basic-table-2_aws_dynamodb_table" {
  type    = string
  default = "oak9.tenant.authstore"
}

variable "basic-table-3_aws_dynamodb_table" {
  type    = string
  default = "oak9.tenant.catalog"
}

variable "basic-table-4_aws_dynamodb_table" {
  type    = string
  default = "oak9.tenant.core"
}

variable "basic-table-5_aws_dynamodb_table" {
  type    = string
  default = "oak9.tenant.validations"
}

variable "basic-table-6_aws_dynamodb_table" {
  type    = string
  default = "serverlessrepo-serverless-form-handler-FormDataTable-OF6EJ6F0M2ZW"
}

variable "basic-table-7_aws_dynamodb_table" {
  type    = string
  default = "ValidationResults"
}

variable "basic-table-8_aws_dynamodb_table" {
  type    = string
  default = "oak9.azure.marketplace.subs"
}

variable "basic-table-9_aws_dynamodb_table" {
  type    = string
  default = "oak9.azure.marketplace.sub.updates"
}
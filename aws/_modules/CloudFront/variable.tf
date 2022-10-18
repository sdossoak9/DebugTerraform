variable "region" {
  default = "us-east-1"
}

variable "cf_s3Bucket" {
  default = "oak9-cf-802"
}

variable "enable_public_access_block" {
  type    = bool
  default = true
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "dns_name" {
  type    = string
  default = ""
}

variable "ui_s3Bucket" {
  type    = string
  default = "console-ui"
}

variable "root_object_path" {
  type    = string
  default = "/index.html"
}

variable "organisation" {
  type    = string
  default = "oak9"
}

variable "application" {
  type    = string
  default = "oak9Console"
}

variable "acm_certificate_arn" {
  type    = string
  default = ""
}

variable "minimum_protocol_version" {
  type    = string
  default = "TLSv1.2_2019"
}
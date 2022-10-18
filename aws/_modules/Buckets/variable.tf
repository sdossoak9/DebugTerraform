variable "region" {
  type    = string
  default = "us-east-2"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "url" {
  type    = string
  default = "console.oak9.cloud"
}

variable "s3Bucket" {
  type    = string
  default = "lambda-code"
}

variable "disable_public_access" {
  type    = bool
  default = true
}

variable "force_destroy" {
  type    = bool
  default = true
}

variable "versioned" {
  type    = bool
  default = true
}
variable "region" {
  type = string
  default = "us-east-1"
}

variable "iamRoleName" {
  type = string
  default = "Oak9SampleFunction_exec_role"
}

variable "lambdaFunctionName" {
  type = string
  default = "Oak9SampleFunction"
}

variable "s3Bucket" {
  type = string
  default = "terraform-sample-bucket"
}

variable "s3Key" {
  type = string
  default = "builds/sample-v1-1-0.zip"
}

variable "handler" {
  type = string
  default = "index.handler"
}

variable "runtime" {
  type = string
  default = "nodejs12.x"
}

variable "apiGatewayName" {
  type = string
  default = "Oak9SampleAPIGateway"
}

variable "apiGatewayStage" {
    type = string
    default = "dev"
}

variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

# ubuntu-trusty-14.04 (x64)
variable "aws_amis" {
  default = {
    "us-east-1" = "ami-5f709f34"
    "us-west-2" = "ami-7f675e4f"
  }
}

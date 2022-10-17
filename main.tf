terraform {
  required_providers {
      aws = {
          source = "hashicorp/aws"
          version = "~> 3.0"
      }
  }
}

# COnfigure the AWS Provider
provider "aws" {
  region = "us-east-2"
  shared_credentials_file = "~/.aws/creds"
}


# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}



module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.0.0"
  # insert the 2 required variables here
}

module "security-group2" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.0.0"
  # insert the 2 required variables here
}

module "testertest" {
  source="github.com/terraform-community-modules/tf_aws_openvpn"
  userid = 3
  usertyper = admin
}

module "testertest2" {
  source="https://terraformmodule.s3.us-east-2.amazonaws.com/testertest123.zip"
}

module "security-grouplocal" {
  source  = "./localModules/security-grouplocal"
  #version = "4.0.0"
  # insert the 2 required variables here
}

module "security-group2local" {
  source  = "./localModules/security-group2local"
  #version = "4.0.0"
  # insert the 2 required variables here
}

module "testertestlocal" {
  source="./localModules/testertestlocal"
  #userid = 3
  #usertyper = admin
}



# module "awsTester" {
#   source="awsS3Bucket/modules/iAmAModule"
#}
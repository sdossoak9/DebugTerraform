variable "region" {
  type    = string
  default = "us-east-2"
}

variable "environment" {
  type    = string
  default = ""
}

variable "profile" {
  type    = string
  default = "dev"
}

variable "asp_environment" {
  type    = string
  default = ""
}

variable "url" {
  type    = string
  default = ""
}

variable "idpUri" {
  type    = string
  default = ""
}

variable "idpClient" {
  type    = string
  sensitive = true
  default = ""
}

variable "s3AccessKey" {
  type    = string
  sensitive = true
  default = ""
}

variable "s3AccessSecret" {
  type    = string
  sensitive = true
  default = ""
}

variable "orgRepoAccessToken" {
  type    = string
  sensitive = true
  default = ""
}

variable "orgRepoUserId" {
  type    = string
  default = ""
}

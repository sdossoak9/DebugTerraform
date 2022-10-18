variable "region" {
  type    = string
  default = "us-east-1"
}

variable "stack" {
  type    = string
  default = ""
}

variable "project_name" {
  type    = string
  default = "consoleApi"
}

variable "aws_app_lb_name" {
  type    = string
  default = "consoleApi-lb"
}

variable "link_aws_api_gateway_vpc_link" {
  type    = string
  default = "api-vpc-link"
}

variable "ecr_repository_name" {
  type    = string
  default = "consoleApi_ecr"
}

variable "min_instance" {
  type    = number
  default = 2
}

variable "max_instance" {
  type    = number
  default = 6
}

variable "eks_cluster_vpc_id" {
  type   = string
  default = ""
}

variable "neptune_endpoint" {
  type = string
  default = ""
}

variable "task_cpu" {
  type = number
  default = 512
}

variable "task_memory" {
  type = number
  default = 2048
}

variable "container_cpu" {
  type = number
  default = 512
}

variable "container_memory" {
  type = number
  default = 2048
}

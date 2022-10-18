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
  default = "prod"
}

variable "dns_name" {
  type    = string
  default = "oak9.io"
}

variable "stack" {
  type    = string
  default = "prod"
}

variable "stage_name" {
  type    = string
  default = "v1"
}

variable "base_path" {
  type    = string
  default = ""
}

variable "neptune_size" {
  type    = string
  default = "db.t3.medium"
}

variable "neptune_count" {
  type    = number
  default = 2
}

variable "task_cpu" {
  type    = number
  default = 4096
}

variable "task_memory" {
  type    = number
  default = 8192
}

variable "container_cpu" {
  type    = number
  default = 2048
}

variable "container_memory" {
  type    = number
  default = 4096
}

variable "ssm-path" {
  type    = string
  default = "/terraform"
}

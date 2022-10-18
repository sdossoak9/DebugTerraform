variable "region" {
  type    = string
  default = "us-east-2"
}

variable "environment" {
  type    = string
  default = "stage"
}

variable "profile" {
  type    = string
  default = "staging"
}

variable "dns_name" {
  type    = string
  default = "oak9.cloud"
}

variable "stack" {
  type    = string
  default = "stage"
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

variable "ssm-path" {
  type    = string
  default = "/terraform"
}

variable "task_cpu" {
  type    = number
  default = 512
}

variable "task_memory" {
  type    = number
  default = 2048
}

variable "container_cpu" {
  type    = number
  default = 512
}

variable "container_memory" {
  type    = number
  default = 2048
}

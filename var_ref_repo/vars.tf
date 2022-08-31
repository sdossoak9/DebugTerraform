variable "vpc_name" {
  type    = string
  default = "ov-vpc-"
}

variable "vpc_cidr" {
  type    = string
  default = ""
}

variable "ipv6_enable_status" {
  type    = bool
  default = false
}

variable "nat_gateway_status" {
  type    = bool
  default = false
}

variable "single_nat_gateway_status" {
  type    = bool
  default = false
}
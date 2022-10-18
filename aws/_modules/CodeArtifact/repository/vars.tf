variable "repository_name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "domain_owner" {
  type = string
}

variable "description" {
  type = string
  default = ""
}

variable "upstream_repo_name" {
  type=string
  default = ""
}

variable "upstream_sac_repo_name" {
  type=string
  default = ""
}

variable "upstream_pypi_repo_name" {
  type=string
  default = ""
}

variable "external_connection_name" {
  type=string
  default = ""
}
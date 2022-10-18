variable "region" {
  type    = string
  default = "us-east-2"
}

variable "environment" {
  type    = string
  default = "security"
}

variable "profile" {
  type    = string
  default = "security"
}

variable "cloudtrail_name" {
  default     = "oak9-management-events"
  description = "Name for the CloudTrail"
  type        = string
}

variable "iam_path" {
  default     = "/"
  description = "Path under which to put the IAM role. Should begin and end with a '/'."
  type        = string
}

variable "lambda_functions" {
  default     = []
  description = "Lambda functions to log. Specify `[\"arn:aws:lambda\"]` for all, or `[ ]` for none."
  type        = list
}

variable "log_group_name" {
  default     = "cloudtrail2cwl"
  description = "Name for CloudTrail log group"
  type        = string
}

variable "retention_in_days" {
  default     = 7
  description = "How long should CloudTrail logs be retained in CloudWatch (does not affect S3 storage). Set to -1 for indefinite storage."
  type        = number
}

variable "tags" {
  default     = {}
  description = "Mapping of any extra tags you want added to resources"
  type        = map(string)
}

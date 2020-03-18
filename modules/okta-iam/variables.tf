variable "okta_app_name" {
  description = "Name of the AWS App that gets created in okta"
}

variable "okta_provider_name" {
  description = "Name of the AWS Identity Provider"
  default     = "okta"
}

variable "aws_role_names" {
  description = "Set of IAM role names to create"
  type        = set(string)
}

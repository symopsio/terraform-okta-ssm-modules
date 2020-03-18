variable "aws_role_names" {
  description = "Set of IAM role names users will be able to log in with"
  default     = ["ExampleOktaIam"]
  type        = set(string)
}

variable "okta_app_name" {
  description = "Name of the AWS okta app"
  default     = "example-okta-iam"
}

variable "okta_org_name" {
  description = "Okta Org Name (like dev-12345678)"
}

variable "okta_provider_name" {
  description = "Name of the AWS okta provider"
  default     = "example-okta-provider"
}

variable "okta_user_email" {
  description = "Email of the Okta AWS user to create"
}

variable "region" {
  default = "us-east-1"
}


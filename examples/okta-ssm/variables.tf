variable "aws_role_name" {
  description = "IAM role name users will be able to log in with"
  default     = "SSMDemo"
}

variable "aws_subnet_id" {
  description = "The id of the AWS subnet to put the demo instance in"
}

variable "okta_app_name" {
  description = "Name of the AWS okta app"
  default     = "SSMDemo"
}

variable "okta_org_name" {
  description = "Okta Org Name (like dev-12345678)"
}

variable "okta_provider_name" {
  description = "Name of the AWS okta provider"
  default     = "ssm-demo-okta-provider"
}

variable "okta_user_email" {
  description = "Email of the Okta user to create"
}

variable "okta_user_first_name" {
  description = "First name of the Okta user to create"
  default     = "EndToEndFirst"
}

variable "okta_user_last_name" {
  description = "Last name of the Okta user to create"
  default     = "EndToEndLast"
}

variable "region" {
  default = "us-east-1"
}

variable "run_as_user" {
  description = "The OS user to log in as if run_as is enabled"
  default     = "ubuntu"
}


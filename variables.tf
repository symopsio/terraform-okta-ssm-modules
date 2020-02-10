variable "region" {
  default = "us-east-1"
}

variable "okta_org_name" {
  description = "Okta Org Name (like dev-12345678)"
}

variable "okta_app_name" {
  description = "Name of the AWS okta app"
  default     = "SSMDemo"
}

variable "okta_user_email" {
  description = "Email of the Okta AWS user to create"
}

variable "aws_role_name" {
  description = "Name of the AWS Role users will be able to log in with"
  default     = "SSMDemo"
}

variable "aws_subnet_id" {
  description = "The id of the AWS subnet to put the demo instnace in"
}

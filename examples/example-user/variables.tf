variable "aws_subnet_id" {
  description = "The id of the AWS subnet to put the demo instnace in"
}

variable "okta_org_name" {
  description = "Okta Org Name (like dev-12345678)"
}

variable "okta_user_email" {
  description = "Email of the Okta AWS user to create"
}

variable "region" {
  default = "us-east-1"
}


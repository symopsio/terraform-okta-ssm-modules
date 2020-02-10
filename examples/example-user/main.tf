terraform {
  required_version = ">= 0.12.7"
}

provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

provider "local" {
  version = "~> 1.0"
}

provider "okta" {
  version = "~> 3.0"
  org_name  = var.okta_org_name
  base_url  = "okta.com"
}

module "okta_ssm_demo" {
  source        = "../../"
  aws_subnet_id = var.aws_subnet_id
  okta_org_name = var.okta_org_name
}

# Create a user that will be able to SSM in to the app
resource "okta_user" "example_user" {
  first_name        = "ExampleFirst"
  last_name         = "ExampleLast"
  login             = var.okta_user_email
  email             = var.okta_user_email
  status            = "ACTIVE"
  group_memberships = [ module.okta_ssm_demo.okta_group_id ]
}

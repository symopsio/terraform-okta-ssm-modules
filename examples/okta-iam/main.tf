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
  org_name  = var.okta_org_name
  base_url  = "okta.com"
}

module "okta_iam" {
  source        = "../../modules/okta-iam"

  okta_app_name = var.okta_app_name
  aws_role_name = var.aws_role_name
}

resource "okta_user" "example_user" {
  first_name        = "ExampleFirst"
  last_name         = "ExampleLast"
  login             = var.okta_user_email
  email             = var.okta_user_email
  status            = "ACTIVE"
  group_memberships = [ module.okta_iam.okta_group_id ]
}

resource "aws_iam_role_policy_attachment" "role-attach" {
  role       = module.okta_iam.aws_role_name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

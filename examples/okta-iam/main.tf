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
  version   = "~> 3.1"
  org_name  = var.okta_org_name
  base_url  = "okta.com"
}

module "okta_iam" {
  source        = "../../modules/okta-iam"

  okta_app_name       = var.okta_app_name
  okta_provider_name  = var.okta_provider_name
  aws_role_names      = var.aws_role_names
}

resource "okta_user" "example_user" {
  first_name        = "ExampleFirst"
  last_name         = "ExampleLast"
  login             = var.okta_user_email
  email             = var.okta_user_email
  status            = "ACTIVE"
  group_memberships = toset(values(module.okta_iam.role_names_to_group_ids))
}

resource "aws_iam_role_policy_attachment" "role-attach" {
  for_each   = toset(keys(module.okta_iam.role_names_to_group_ids))
  role       = each.key
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

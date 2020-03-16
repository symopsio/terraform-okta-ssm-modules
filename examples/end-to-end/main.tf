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
  version = "~> 3.1"
  org_name  = var.okta_org_name
  base_url  = "okta.com"
}

module "ssm_instance" {
  source    = "../../modules/ssm-instance"
  subnet_id = var.aws_subnet_id
}

module "okta_iam" {
  source        = "../../modules/okta-iam"
  okta_app_name = var.okta_app_name
  aws_role_name = var.aws_role_name
}

# Attach the SSM access policy to the role that the Okta app logs in with
resource "aws_iam_role_policy_attachment" "user-policy-attach" {
  role       = module.okta_iam.aws_role_name
  policy_arn = module.ssm_instance.user_policy_arn
}

# Give the Okta role readonly access so we can go to the console with it
resource "aws_iam_role_policy_attachment" "role-attach" {
  role       = module.okta_iam.aws_role_name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Create a user that will be able to SSM in to the app
resource "okta_user" "example_user" {
  first_name        = var.okta_user_first_name
  last_name         = var.okta_user_last_name
  login             = var.okta_user_email
  email             = var.okta_user_email
  status            = "ACTIVE"
  group_memberships = [ module.okta_iam.okta_group_id ]
}

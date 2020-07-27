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

module "ssm_user" {
  source = "../../modules/ssm-user"

  policy_name = var.aws_role_name
}

module "ssm_preferences" {
  source      = "../../modules/ssm-preferences"
  run_as_user = var.run_as_user
}

module "ssm_instance" {
  source    = "../../modules/ssm-instance"
  subnet_id = var.aws_subnet_id
}

module "okta_iam" {
  source              = "../../modules/okta-iam"
  okta_app_name       = var.okta_app_name
  okta_provider_name  = var.okta_provider_name
  aws_role_names      = [ var.aws_role_name ]
}

# Attach the SSM access policy to the roles that the Okta app logs in with
resource "aws_iam_role_policy_attachment" "user-policy-attach" {
  depends_on = [ module.okta_iam ]
  role       = var.aws_role_name
  policy_arn = module.ssm_user.policy_arn
}

# Give the Okta roles readonly access so we can go to the console with it
resource "aws_iam_role_policy_attachment" "role-attach" {
  depends_on = [ module.okta_iam ]
  role       = var.aws_role_name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Create a user that will be able to SSM in to the app
resource "okta_user" "example_user" {
  first_name        = var.okta_user_first_name
  last_name         = var.okta_user_last_name
  login             = var.okta_user_email
  email             = var.okta_user_email
  status            = "ACTIVE"
  group_memberships = [
    module.okta_iam.role_names_to_group_ids[var.aws_role_name]
  ]
}

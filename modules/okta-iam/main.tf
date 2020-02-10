# Defining the provider name to avoid a circular dependency between the okta
# provider in AWS and the Okta App config
locals {
  provider_name = "okta"
}

data "aws_caller_identity" "current" {}

# This group name needs to match the groupFilter regex defined in the okta app
# The group name tells okta what role and account to go to.
resource "okta_group" "group" {
  name = "aws#${var.okta_app_name}#${var.aws_role_name}#${data.aws_caller_identity.current.account_id}"
}

resource "okta_app_saml" "aws" {
  preconfigured_app = "amazon_aws"
  label             = var.okta_app_name
  key_years_valid   = 3

  groups = [okta_group.group.id]

  app_settings_json = <<EOT
{
  "appFilter":"okta",
  "awsEnvironmentType":"aws.amazon",
  "groupFilter": "^aws\\#\\S+\\#(?{{role}}[\\w\\-]+)\\#(?{{accountid}}\\d+)$",
  "joinAllRoles": false,
  "loginURL": "https://console.aws.amazon.com/ec2/home",
  "roleValuePattern": "arn:aws:iam::$${accountid}:saml-provider/${local.provider_name},arn:aws:iam::$${accountid}:role/$${role}",
  "sessionDuration": 3600,
  "useGroupMapping": true
}
EOT
}

# Create the AWS proivder for our SAML app, using the metadata we
# created above
resource "aws_iam_saml_provider" "okta" {
  name                   = local.provider_name
  saml_metadata_document = okta_app_saml.aws.metadata
}

# Lets the SAML app assume Roles
data "aws_iam_policy_document" "okta" {

  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_saml_provider.okta.arn]
    }

    actions = [
      "sts:AssumeRoleWithSAML",
    ]

    condition {
      test     = "StringEquals"
      variable = "SAML:aud"
      values   = ["https://signin.aws.amazon.com/saml"]
    }

  }
}

# A role that trusts the SAML app.
# The role has no policies, those need to get created by consumers
resource "aws_iam_role" "role" {
  name               = var.aws_role_name
  assume_role_policy = data.aws_iam_policy_document.okta.json
}


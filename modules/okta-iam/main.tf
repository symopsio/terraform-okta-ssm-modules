data "aws_caller_identity" "current" {}

# The group names need to match the groupFilter regex defined in the okta app
# The group name tells okta what role and account to go to.
resource "okta_group" "groups" {
  for_each = var.aws_role_names
  name     = "aws#${var.okta_app_name}#${each.value}#${data.aws_caller_identity.current.account_id}"
}

resource "okta_app_saml" "aws" {
  preconfigured_app = "amazon_aws"
  label             = var.okta_app_name
  key_years_valid   = 3

  groups = [
    for group in okta_group.groups:
    group.id
  ]

  app_settings_json = <<EOT
{
  "appFilter":"okta",
  "awsEnvironmentType":"aws.amazon",
  "groupFilter": "^aws\\#\\S+\\#(?{{role}}[\\w\\-]+)\\#(?{{accountid}}\\d+)$",
  "joinAllRoles": false,
  "loginURL": "https://console.aws.amazon.com/ec2/home",
  "roleValuePattern": "arn:aws:iam::$${accountid}:saml-provider/${var.okta_provider_name},arn:aws:iam::$${accountid}:role/$${role}",
  "sessionDuration": 3600,
  "useGroupMapping": true
}
EOT
}

# Create the AWS proivder for our SAML app, using the metadata we
# created above
resource "aws_iam_saml_provider" "okta" {
  name                   = var.okta_provider_name
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

# Roles that trust the SAML app.
# The role has no policies, those need to get created by consumers
resource "aws_iam_role" "roles" {
  for_each           = var.aws_role_names
  name               = each.value
  assume_role_policy = data.aws_iam_policy_document.okta.json
}

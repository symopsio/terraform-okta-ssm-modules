# okta-iam

Creates an Okta AWS App and AWS IAM Roles that are connected to it.

Module consumers need to attach policies to the output roles and add users to the output groups in order to complete the setup.

## How to reference the provisioned roles and groups

For the AWS roles, you can simply use the role names that you supplied:

    # Include a dependency on the okta-iam module to ensure
    # the role exists before attaching to it
    resource "aws_iam_role_policy_attachment" "role-attach" {
      depends_on  = module.okta_iam # change to your module name
      role       = <my-role-name>
      policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
    }

For the Okta groups, you can pull those from the `role_names_to_group_ids` output:

    resource "okta_user" "example_user" {
      first_name        = var.okta_user_first_name
      last_name         = var.okta_user_last_name
      login             = var.okta_user_email
      email             = var.okta_user_email
      status            = "ACTIVE"
      group_memberships = [
        module.okta_iam.role_names_to_group_ids[<my-role-name>]
      ]
    }

# ssm_preferences module

This module defines account-wide preferences for Session Manager.

1. Creates and enables a CloudWatch logs group that sessions get shipped to.
2. Enables "Run As" user support, along with configuring the default user if a different one is not specified on the instance role.

## Import existing preferences

If you've already configured Session Manager preferences in the AWS console, then terraform will complain that the resource you're creating already exists:

```
Error: Error creating SSM document: DocumentAlreadyExists: Document with same name SSM-SessionManagerRunShell already exists
```

You can resolve this by importing the existing document into Terraform state, and then applying our changes to it:

```
terraform import module.ssm_preferences.aws_ssm_document.regional_settings SSM-SessionManagerRunShell
```

## RunAs support

You can tell Session Manager to log in to instances as a different user (such as `ubuntu`), in one of two ways:

1. Configuring a global preference for your AWS Account (as done by the `ssm_preferences` module).
2. Configuring an `SSMSessionRunAs` tag on your IAM roles that configures the OS user (as done in the `ssm` module).

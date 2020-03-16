# ssm-instance

Creates an EC2 instance that is accessible via AWS Systems Manager Session Manager.

Uses the [default Amazon managed policy](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-getting-started-instance-profile.html) to give the EC2 instance the ability to accept SSM sessions.

## user_policy_arn

In addition to the EC2 instance, this module outputs an IAM policy that you can attach to a role that grants users access to connect to the instance with Session Manager.

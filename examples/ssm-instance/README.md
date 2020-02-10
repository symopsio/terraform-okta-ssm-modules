# ssm-instance

This example provisions an ssm demo instance in the region's default VPC.

Does not use the specific IAM policy created by the ssm-instance module, you need to run with admin permissions for start-session to work.

Once the instance is created, you can log in with admin permissions using:

    $ aws ssm start-session --target <instance-id>

## SSM Setup

You need to install the [session manager plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html) for the AWS CLI for `start-session` to work.


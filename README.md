# terraform-okta-ssm-demo

Creates an Okta AWS App and an EC2 instance that you can use to demo AWS Systems Manager [Session Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html).

* Users authenticate with Okta and then are able to gain SSH access to the instance
* The instance has no EC2 key and the security group has no ingress rules and only http/https egress rules, but yet we are able to get in to it. Yay!

## Instance Profile Configuration

This demo uses the [default Amazon managed policy](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-getting-started-instance-profile.html) to give the demo EC2 instance the ability to accept SSM sessions.

## SSM Access

Currently SSM access through the AWS console only is supported (CLI instructions/setup coming soon).

## Okta Configuration

### Authentication

Set the OKTA_API_TOKEN env variable to a valid token

### Plugin Configuration
Do to an open issue w/the okta provider you need to manually download the okta plugin and put it in your .terraform/plugins directory:

    $ wget https://github.com/articulate/terraform-provider-okta/releases/download/v3.0.38/terraform-provider-okta-darwin-amd64.zip
    $ unzip terraform-provider-okta-darwin-amd64.zip
    $ mv terraform-provider-okta_v3.0.38_x4 .terraform/plugins/darwin_amd64/


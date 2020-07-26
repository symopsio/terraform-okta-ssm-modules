# terraform-okta-ssm-modules

Terraform modules that help you explore Okta and AWS Session Manager integrations.

## About session manager

For the details on what makes Session Manager so cool, check out:

* [AWS Session Manager: less infrastructure, more features](https://blog.symops.io/2020/03/20/aws-session-manager-less-infrastructure-more-features.html)
* [AWS Session Manager: SSH tunnels with less user management](https://blog.symops.io/2020/03/23/aws-session-manager-ssh-tunnels-with-less-user-management.html)

## Examples

The [examples](examples) folder includes end-to-end configurations for people that want to spin something up quickly.

### okta-ssm

You'll need a free Okta developer account and an AWS account where you have administrative privileges for the example to work.

This example provisions:

1. An Okta User that can log in to AWS with permissions to run Session Manager sessions.
2. An EC2 instance that is set up with the right permissions for Session Manager and is tagged to let the Okta User access it.

### rds-tunnel

You'll need an AWS account where you have administrative privileges for the example to work. You can use [bin/ec2-tunnel](bin/ec2-tunnel) to tunnel to the database once things are provisioned.

This example provisions:

1. A non-public RDS free tier eligible database
2. A bastion EC2 instance that enables Session Manager based SSH tunneling to the database


## About the modules

* [ssm-instance](modules/ssm-instance): Defines an EC2 instance that can be accessed with Session Manager
* [ssm-user](modules/ssm-user): Defines a user policy that allows access to instances in a given environment tag
* [cwagent](modules/cwagent): Configures the CloudWatch Logs agent on an EC2 instance to enable logging of Session Manager sessions
* [okta-iam](modules/okta-iam): Enable federated login to AWS via Okta groups
* [rds-demo](modules/rds-demo): A free tier eligible RDS database for demoing SSH tunneling

## Get in touch

Please reach out to info@symops.io with any questions on these modules or help getting them running.

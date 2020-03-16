# terraform-okta-ssm-modules

Terraform modules that help you explore Okta and AWS Session Manager integrations.

## About session manager

For the details on what makes Session Manager so cool, check out [AWS Session Manager: less infrastructure, more features](docs/AWSSessionManagerLessInfrastructureMoreFeatures.md).

## End to end example

The `examples` folder includes an end-to-end configuration for people that want to spin something up quickly. The end-to-end example will provision:

1. An Okta User that can log in to AWS with permissions to run Session Manager sessions.
2. An EC2 instance that is set up with the right permissions for Session Manager and is tagged to let the Okta User access it.

You'll need a free Okta developer account and an AWS account where you have administrative privileges for the example to work.

## About the modules

* `ssm_instance`: Defines an EC2 instance that can be accessed with Session Manager
* `cwagent`: Configures the CloudWatch Logs agent on an EC2 instance to enable logging of Session Manager sessions
* `okta-iam`: Enable federated login to AWS via Okta groups

## Get in touch

Please reach out to info@symops.io with any questions on these modules or help getting them running.

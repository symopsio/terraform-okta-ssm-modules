# AWS Session Manager: SSH tunnels with less user management

Hey I'm [Jon](https://www.jonbass.me/), CTO at Sym. First of all, I hope readers of this are safe and taking care of themselves and their families in these crazy times. If you are looking for some diversion, I'm following up here on [AWS Session Manager: less infrastructure, more features](AWSSessionManagerLessInfrastructureMoreFeatures.md). The post sparked a bunch of [great discussion on HN](https://news.ycombinator.com/item?id=22592875).
 
I'm going to focus here on how to use SSM for SSH tunnels, a hot topic from the HN thread. There's some great prior art on this so will be linking to that and adding additional commentary on what you can do, and what the limitations are.

## SSH Tunnels Explained

[New – Port Forwarding Using AWS System Manager Session Manager](https://aws.amazon.com/blogs/aws/new-port-forwarding-using-aws-system-manager-sessions-manager/) from the AWS blog does a great job of describing what SSH Tunneling is all about:

> SSH tunneling is a powerful but lesser known feature of SSH that alows you to to create a secure tunnel between a local host and a remote service. Let’s imagine I am running a web server for easy private file transfer between an EC2 instance and my laptop. ... When the tunnel is established, I can point my browser at http://localhost:9999 to connect to my private web server on port 80.

## SSH tunneling to RDS and other services

The AWS Documentation on port forwarding focuses on how to use tunneling to access a service running on the remote EC2 instance you're connecting to, but it doesn't make it clear how to use tunneling to access services that are running somewhere else in your AWS infrastructure (like RDS!).

The good news is there's an awesome tutorial from Transcend on this - [Secure RDS Access through SSH over AWS SSM](https://codelabs.transcend.io/codelabs/aws-ssh-ssm-rds/index.html). They provide a step-by-step walkthrough of how to configure tunneling for RDS access. 

The key takeaways from the post are:

1. You DO need to run a bastion instance in order to connect to RDS or other services.
2. You DONT need this bastion to allow public internet ingress. It can run in private subnets, and as long as the instance has outbound NAT access and IAM permissions to talk to SSM you're good.

### Limitations of SSM-based tunneling

Using SSM to tunnel to RDS or other backend services requires you to wrap your SSM calls in SSH calls. This has some drawbacks:

* Unless you are able to set up EC2 Instance Connect ([below](#using-ec2-instance-connect-to-simplify-user-management-on-your-bastion)), you will need to ensure that users have authorized keys on the bastion instance you're connecting to.
* You don't get logging of the session activity like you do for interactive sessions. The SSM API actions will get logged to CloudTrail but that's it.

### Why do you need to use SSH?

You need to use SSH so that you can forward a port from a backend service that is not running on the instance using `ProxyCommand`, as SSM does not support this directly. With `ProxyCommand`, you end up using SSM just to establish connectivity to your instance. You are using your local SSH configuration to actually set up an interactive shell, so you need the standard authorized keys setup for things to work.

This snippet from [bin/ec2-tunnel](../bin/ec2-tunnel) shows how you tell SSM to just open a network connection and not to start a shell. Note the `--document AWS-StartSSHSession` parameter. This is different from the default `SSM-SessionManagerRunShell` document, which starts an interactive shell for you without going through SSH.

    -o ProxyCommand="${aws_cli} ssm start-session --target %h --document AWS-StartSSHSession --parameters portNumber=%p" \

## Using EC2 Instance Connect to simplify user management on your bastion

If you can use Amazon Linux 2 or Ubuntu 16.04+, the Transcend blog post highlights a related feature from AWS that eases your infrastructure administrative burden. Rather than provision a bunch of long-lived authorized SSH keys on your bastion instance, you can instead use EC2 Instance Connect to authorize a public key temporarily. The following snippet generates a local keypair and sends the public key to a user on a remote EC2 instance:

    echo -e 'y\n' | ssh-keygen -t rsa -f /tmp/temp -N '' >/dev/null 2>&1
    aws ec2-instance-connect send-ssh-public-key \
      --instance-id <instance-id> \
      --availability-zone <az> \
      --instance-os-user ec2-user \
      --ssh-public-key file:///tmp/temp.pub

### Limitations of EC2 Instance Connect

EC2 Instance Connect currently has [limited control](https://docs.aws.amazon.com/IAM/latest/UserGuide/list_amazonec2instanceconnect.html) over constraining access to a subset of your instances. You can't, for example, put in a tag-based condition to say that users can only use instance connect to instances with a certain tag key or value.

The available constraints on access are to call out specific instance ids, or to use [ec2:osuser](https://docs.aws.amazon.com/IAM/latest/UserGuide/list_amazonec2instanceconnect.html#amazonec2instanceconnect-ec2_osuser). This constraint lets you ensure that users can only add authorized keys to a specific OS user, which is useful if you want to create a less privileged user than `ec2-user` or `ubuntu` for this use case.

## Trying it out

I've added an [rds-tunnel](../examples/rds-tunnel) example to the [terraform-okta-ssm-modules](https://github.com/symopsio/terraform-okta-ssm-modules) repo that spins up an RDS database and an SSM-enabled bastion. There's also an [ec2-tunnel](../bin/ec2-tunnel)  script you can use to actually connect.

## Further reading

As mentioned above, check out [Secure RDS Access through SSH over AWS SSM](https://codelabs.transcend.io/codelabs/aws-ssh-ssm-rds/index.html) from Transcend.

Thanks for all the stars and comments on this blog series. I think the next post will address something else that came up in the HN comments, related to potential weaknesses in using the default AWS managed policies for access, as well as what kinds of custom policies might make sense. Please send me a Twitter DM ([@firstmorecoffee](https://twitter.com/firstmorecoffee)) or email ([jon@symops.io](mailto:jon@symops.io)) with your feedback.

## About Sym

Sym Access enables just-in-time access to your cloud infrastructure with workflows that developers will love and ops teams can rely on. Automate access and provide ops teams visibility and reports for easy audits. [Subscribe to our mailing list!](https://symops.io/subscribe)

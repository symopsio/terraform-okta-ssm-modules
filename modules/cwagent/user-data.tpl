#!/bin/bash
echo "Installing collectd..."
yum install -y ca-certificates collectd
echo "Installing cloudwatch agent..."
rpm -Uvh https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
echo "Configuring cloudwatch agent..."
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config  -m ec2 \
  -c ssm:AmazonCloudWatch-config-${ssm_param_suffix} -s
echo "Bootstrap complete!"

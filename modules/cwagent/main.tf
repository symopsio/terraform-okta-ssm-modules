locals {
  user_data  = templatefile("${path.module}/user-data.tpl", 
    {ssm_param_suffix = var.ssm_param_suffix})
}

data "aws_iam_policy" "instance_policy" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# The standard instance_policy above grants instances read access to 
# SSM params that are prefixed with "AmazonCloudwatch-"
resource "aws_ssm_parameter" "ssm_param" {
  name        = "AmazonCloudWatch-config-${var.ssm_param_suffix}"
  description = "Standard Cloudwatch Config"
  type        = "String"
  value       = file("${path.module}/std-config.json")
}


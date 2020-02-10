output "aws_role_name" {
  description = "The name of the AWS Role that Okta users can assume"
  value       = module.okta_iam.aws_role_name
}

output "instance_role_name" {
  description = "The name of the instance role that the demo instance uses"
  value       = module.ssm_instance.instance_role_name
}

output "okta_group_id" {
  description = "The id of the okta group with permissions to the SSM role"
  value       = module.okta_iam.okta_group_id
}

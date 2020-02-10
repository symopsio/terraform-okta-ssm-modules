output "instance_role_name" {
  description = "The name of the instance role that the demo instance uses"
  value       = aws_iam_role.instance_role.name
}

output "user_policy_arn" {
  description = "The ARN of the policy that grants users access to the instance"
  value       = aws_iam_policy.ssm_user_policy.arn
}

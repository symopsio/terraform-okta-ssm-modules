output "policy_arn" {
  description = "The ARN of the policy that grants users access to the instance"
  value       = aws_iam_policy.ssm_user_policy.arn
}

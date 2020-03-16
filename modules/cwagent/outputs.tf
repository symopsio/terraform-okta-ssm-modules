output "instance_policy" {
  description = "Managed policy that lets instances use Cloudwatch Agent"
  value       = data.aws_iam_policy.instance_policy
}

output "user_data" {
  description = "User data that will install and configure the Cloudwatch Agent"
  value       = local.user_data
}

output "okta_group_id" {
  description = "The ID of the Okta Group that users should be added to"
  value       = okta_group.group.id
}

output "aws_role_name" {
  description = "The Name of the AWS role that users will be able to log in with"
  value       = aws_iam_role.role.name
}

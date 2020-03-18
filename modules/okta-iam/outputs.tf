output "role_names_to_group_ids" {
  description = "Mapping of IAM role names to Okta group ids"
  value       = {
    for role in aws_iam_role.roles:
    role.name => okta_group.groups[role.name].id
  }
}

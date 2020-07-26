output "instance_role_name" {
  description = "The name of the instance role that the demo instance uses"
  value       = aws_iam_role.instance_role.name
}

output "instance_id" {
  description = "The id of the instance"
  value       = aws_instance.ssm_instance.id
}

output "instance_az" {
  description = "The availability zone of the instance"
  value       = aws_instance.ssm_instance.availability_zone
}

output "instance_security_group_id" {
  description = "The security group of the instance"
  value       = aws_security_group.sg.id
}

output "db_security_group_id" {
  description = "The database security group"
  value       = aws_security_group.sg.id
}

output "db_endpoint" {
  description = "The database endpoint"
  value       = module.rds.this_db_instance_endpoint
}

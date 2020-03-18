output "instance_id" {
  description = "The id of the instance"
  value       = module.ssm_instance.instance_id
}

output "instance_az" {
  description = "The availability zone of the instance"
  value       = module.ssm_instance.instance_az
}

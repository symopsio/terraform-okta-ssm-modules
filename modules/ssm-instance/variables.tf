variable "subnet_id" {
  description = "The subnet_id to put the demo instance in"
}

variable instance_name {
  description = "The name of the EC2 instance to create"
  default     = "ssm-instance"
}

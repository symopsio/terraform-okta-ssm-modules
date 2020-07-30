variable "instance_name" {
  description = "The name of the EC2 instance to create"
  default     = "ssm-instance"
}

variable "instance_role" {
  description = "The name of the IAM role to create"
  default     = "SSMInstance"
}

variable "session_kms_key_arn" {
  description = "The arn of the kms key used to encrypt sessions"
}

variable "subnet_id" {
  description = "The subnet_id to put the demo instance in"
}

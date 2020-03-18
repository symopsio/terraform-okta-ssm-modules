variable "identifier" {
  description = "RDS Database Identifier"
  default     = "rds-demo"
}

variable "instance_class" {
  description = "RDS Instance Class to create"
  default     = "db.t2.micro" # free tier
}

# This should be changed manually after provisioning, terraform doesn't check if
# this has changed.
variable "password" {
  description = "DB user password"
  default     = "YourPwdShouldBeLongAndSecure!"
}

variable "subnet_ids" {
  description = "List of subnets for deployment"
}

variable "tags" {
  description = "Tags for the infrastructure"
  type        = map(string)
  default     = {}
}

# NOTE: Do NOT use 'user' as the value for 'username' as it throws:
# "Error creating DB Instance: InvalidParameterValue: MasterUsername
# user cannot be used as it is a reserved word used by the engine"
variable "username" {
  description = "DB user name"
  default     = "rds_demo"
}

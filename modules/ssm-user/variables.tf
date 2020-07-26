variable "environment" {
  description = "The name of the environment that users can SSH into"
  default     = "staging"
}

variable "policy_name" {
  description = "The name of the IAM policy to create"
}

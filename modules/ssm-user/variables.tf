variable "session_kms_key_arn" {
  description = "The arn of the kms key used to encrypt sessions"
}

variable "tag_key" {
  description = "The tag key you want to filter access by"
  default     = "Environment"
}

variable "tag_value" {
  description = "The tag value you want to filter access by"
  default     = "staging"
}

variable "policy_name" {
  description = "The name of the IAM policy to create"
}

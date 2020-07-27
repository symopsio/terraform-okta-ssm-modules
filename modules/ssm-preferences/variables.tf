variable "log_group_name" {
  description = "Name of the log group to ship session logs to"
  default     = "/ssm/sessions"
}

variable "logs_retention_in_days" {
  description = "How long to preserve session logs for"
  default     = 1827 # Five years
}

variable "run_as_enabled" {
  description = "Whether or not to enable run as"
  default     = true
  type        = bool
}

variable "run_as_user" {
  description = "The OS user to log in as if run_as is enabled"
  default     = "ubuntu"
}


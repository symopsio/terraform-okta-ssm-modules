variable "aws_subnet_ids" {
  description = "The ids of the AWS subnet to put the demo instance in"
  type        = list(string)
}

variable "region" {
  default = "us-east-1"
}

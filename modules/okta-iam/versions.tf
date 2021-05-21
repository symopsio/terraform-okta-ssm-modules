terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.0"
    }
    okta = {
      source  = "oktadeveloper/okta"
      version = "~> 3.0"
    }
  }
  required_version = ">= 0.12"
}

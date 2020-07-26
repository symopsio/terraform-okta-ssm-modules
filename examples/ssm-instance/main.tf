terraform {
  required_version = ">= 0.12.7"
}

provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

provider "local" {
  version = "~> 1.0"
}

module "ssm_user" {
  source = "../../modules/ssm-user"

  policy_name = "SSMUser"
}

module "ssm_instance" {
  source = "../../modules/ssm-instance"

  subnet_id = data.aws_subnet.selected.id
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "selected" {
  availability_zone = "${var.region}a"
  default_for_az    = true
  vpc_id            = data.aws_vpc.default.id
}

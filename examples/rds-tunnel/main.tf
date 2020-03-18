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

module "ssm_instance" {
  source        = "../../modules/ssm-instance"
  instance_name = "ssm-rds-instance"
  instance_role = "SSMRDSInstance"
  subnet_id     = element(var.aws_subnet_ids, 0)
}

module "rds_demo" {
  source     = "../../modules/rds-demo"
  subnet_ids = var.aws_subnet_ids
}

# Attach the EC2 Instance Connect policy to the instance role
resource "aws_iam_role_policy_attachment" "ec2-instance-connect-attach" {
  depends_on = [ module.ssm_instance ]
  role       = module.ssm_instance.instance_role_name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceConnect"
}

# Allow the instance to hit the DB
resource "aws_security_group_rule" "instance_egress" {
  type                     = "egress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = module.rds_demo.db_security_group_id
  security_group_id        = module.ssm_instance.instance_security_group_id
  description              = "To RDS"
}

# Allow the DB to accept connections from the instance
resource "aws_security_group_rule" "rds_ingress" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = module.ssm_instance.instance_security_group_id
  security_group_id        = module.rds_demo.db_security_group_id
  description              = "From Bastion"
}

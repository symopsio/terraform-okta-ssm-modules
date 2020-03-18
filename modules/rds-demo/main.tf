module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier = var.identifier

  engine            = "postgres"
  engine_version    = "11.6"
  instance_class    = var.instance_class
  allocated_storage = 5
  storage_encrypted = false # not supported for t2.micro

  # kms_key_id        = "arm:aws:kms:<region>:<account id>:key/<kms key id>"
  # Name is the initial database name to create
  name = var.username

  username = var.username

  password = var.password
  port     = "5432"

  vpc_security_group_ids = [aws_security_group.sg.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  tags = var.tags

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  # DB subnet group
  subnet_ids = var.subnet_ids

  # DB parameter group
  family = "postgres11"

  # DB option group
  major_engine_version = "11"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = var.identifier

  # Database Deletion Protection
  deletion_protection = false
}

resource "aws_security_group" "sg" {
  vpc_id = data.aws_subnet.selected.vpc_id
  tags = {
    Name = "${var.identifier}-db"
  }
}

data "aws_subnet" "selected" {
  id = element(var.subnet_ids, 0)
}

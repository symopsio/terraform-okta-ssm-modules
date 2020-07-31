module "cwagent" {
  source           = "../cwagent"
  ssm_param_suffix = var.instance_name
}

data "aws_subnet" "selected" {
  id = "${var.subnet_id}"
}

# Create a security group with no ingress rules
resource "aws_security_group" "sg" {
  vpc_id = data.aws_subnet.selected.vpc_id
  tags = {
    Name = var.instance_name
  }
}

resource "aws_security_group_rule" "http_egress" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg.id
  cidr_blocks              = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https_egress" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg.id
  cidr_blocks              = ["0.0.0.0/0"]
}

# Create an instance that we can get into with session manager
resource "aws_instance" "ssm_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  instance_type          = "t2.micro"
  monitoring             = true
  subnet_id              = data.aws_subnet.selected.id
  user_data              = module.cwagent.user_data
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = var.instance_name,
    Environment = "staging"
  }
}

resource "aws_iam_role" "instance_role" {
  name               = var.instance_role
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = var.instance_role
  role = aws_iam_role.instance_role.name
}

# Use the standard Amazon SSM policy to let the instances accept SSM sessions
resource "aws_iam_role_policy_attachment" "ssm-attach" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Give the instance permissions to write to CloudWatch logs
resource "aws_iam_role_policy_attachment" "cwagent-attach" {
  role       = aws_iam_role.instance_role.name
  policy_arn = module.cwagent.instance_policy.arn
}

data "aws_iam_policy_document" "session_key_policy" {
  statement {
    effect = "Allow"
    actions = [ "kms:Decrypt" ]
    resources = [ var.session_kms_key_arn ]
  }
}

resource "aws_iam_policy" "ssm_user_policy" {
  description = "Enables KMS encryption of Session Manager Sessions"
  policy = data.aws_iam_policy_document.session_key_policy.json
}

resource "aws_iam_role_policy_attachment" "kms-session-attach" {
  role       = aws_iam_role.instance_role.name
  policy_arn = aws_iam_policy.ssm_user_policy.arn
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = [
      "amzn2-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"
    values = [
      "amazon",
    ]
  }
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


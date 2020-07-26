# Create a policy that lets the SSM user start sessions on instances with the
# right environment and terminate their own sessions
data "aws_iam_policy_document" "ssm_user" {
    statement {
      effect = "Allow"
      actions = [ "ssm:StartSession" ]
      resources = [
        "arn:aws:ec2:*:*:instance/*",
      ]
      condition {
        test = "StringLike"
        variable = "ssm:resourceTag/Environment"
        values = [ var.environment ]
      }
    }
    statement {
      effect = "Allow"
      actions = [ "ssm:StartSession" ]
      resources = [
        "arn:aws:ssm:*:*:document/AWS-StartSSHSession"
      ]
    }
    statement {
      effect = "Allow"
      actions = [
        "ssm:DescribeSessions",
        "ssm:GetConnectionStatus",
        "ssm:DescribeInstanceProperties",
        "ec2:DescribeInstances"
      ]
      resources = [ "*" ]
    }
    statement {
      effect = "Allow"
      actions = [ "ssm:TerminateSession" ]
      resources = [ "arn:aws:ssm:*:*:session/$${aws:username}-*" ]
    }
}

resource "aws_iam_policy" "ssm_user_policy" {
  name = var.policy_name
  description = "Grants users SSM access to instances in environment ${var.environment}"
  policy = data.aws_iam_policy_document.ssm_user.json
}

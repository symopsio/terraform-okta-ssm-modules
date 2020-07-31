# Create a policy that lets the SSM user start sessions on instances with the
# right tag and terminate their own sessions
data "aws_iam_policy_document" "ssm_user" {
    statement {
      effect = "Allow"
      actions = [ "ssm:StartSession", "ssm:SendCommand" ]
      resources = [
        "arn:aws:ec2:*:*:instance/*",
      ]
      condition {
        test = "StringLike"
        variable = "ssm:resourceTag/${var.tag_key}"
        values = [ var.tag_value ]
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
      actions = [ "ssm:SendCommand" ]
      resources = [
        "arn:aws:ssm:*:*:document/AWS-RunShellScript"
      ]
    }
    statement {
      effect = "Allow"
      actions = [
        "ssm:ListCommands",
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
  description = "Grants users SSM access to instances tagged with ${var.tag_key}:${var.tag_value}"
  policy = data.aws_iam_policy_document.ssm_user.json
}

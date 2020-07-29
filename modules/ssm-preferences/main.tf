resource "aws_ssm_document" "regional_settings" {
  name          = "SSM-SessionManagerRunShell"
  document_type = "Session"

  content = <<DOC
  {
    "schemaVersion": "1.0",
    "description": "Document to hold regional settings for Session Manager",
    "sessionType": "Standard_Stream",
    "inputs": {
      "cloudWatchLogGroupName": "${aws_cloudwatch_log_group.logs.name}",
      "cloudWatchEncryptionEnabled": true,
      "runAsEnabled": ${var.run_as_enabled},
      "runAsDefaultUser": "${var.run_as_user}"
    }
  }
  DOC
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = var.log_group_name
  retention_in_days = var.logs_retention_in_days
  kms_key_id        = aws_kms_key.log_key.arn
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "log_key_policy" {
  statement {
    effect = "Allow"
    actions = [ "kms:*" ]
    resources = [ "*" ]
    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = [ "*" ]
    principals {
      type        = "Service"
      identifiers = [
        "logs.${data.aws_region.current.name}.amazonaws.com"
      ]
    }
    condition {
      test = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values = [
        "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.log_group_name}"
      ]
    }
  }
}

resource "aws_kms_key" "log_key" {
  description             = "KMS Key For SSM Log Encryption"
  policy                  = data.aws_iam_policy_document.log_key_policy.json
}

data "aws_iam_policy_document" "session_key_policy" {
  statement {
    effect = "Allow"
    actions = [ "kms:*" ]
    resources = [ "*" ]
    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = [ "*" ]
    principals {
      type        = "Service"
      identifiers = [
        "logs.${data.aws_region.current.name}.amazonaws.com"
      ]
    }
    condition {
      test = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values = [
        "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.log_group_name}"
      ]
    }
  }
}

resource "aws_kms_key" "session_key" {
  description             = "KMS Key For SSM Sessions"
  policy                  = data.aws_iam_policy_document.session_key_policy.json
}

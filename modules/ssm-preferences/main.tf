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
          "cloudWatchEncryptionEnabled": false,
          "runAsEnabled": ${var.run_as_enabled},
          "runAsDefaultUser": "${var.run_as_user}"
      }
  }
DOC
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = var.log_group_name
  retention_in_days = var.logs_retention_in_days
}

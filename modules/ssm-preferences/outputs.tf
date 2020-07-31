output "session_kms_key_arn" {
  description = "Arn of the KMS key used to encrypt sessions"
  value       = aws_kms_key.session_key.arn
}

output "ssm_profile_name" {
  description = "SSM profile name"
  value       = aws_iam_instance_profile.ssm_profile.name
}

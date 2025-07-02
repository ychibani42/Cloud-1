output "env_file_content" {
  value     = data.aws_secretsmanager_secret_version.env_version.secret_string
  sensitive = true
}

output "instance_public_IP" {
  value = aws_eip.web.public_ip
}
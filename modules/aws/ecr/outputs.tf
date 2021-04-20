# modules/aws/ecr/outputs.tf

output "url" {
  value = aws_ecr_repository.this.repository_url
}


output "username" {
  value = data.aws_ecr_authorization_token.this.user_name
}


output "password" {
  value     = data.aws_ecr_authorization_token.this.password
  sensitive = true
}

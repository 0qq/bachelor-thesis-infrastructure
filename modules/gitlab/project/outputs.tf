# modules/gitlab/project/outputs.tf

output "token" {
  value     = data.gitlab_project.this.runners_token
  sensitive = true
}

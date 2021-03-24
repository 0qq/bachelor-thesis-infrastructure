output "infrustructure_repository_url" {
  value = gitlab_project.infrastructure_repository.ssh_url_to_repo

}


output "project_repository_url" {
  value = gitlab_project.project_repository.ssh_url_to_repo
}

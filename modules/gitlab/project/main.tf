# modules/gitlab/project/main.tf

terraform {
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "3.6.0"
    }
  }
}


data "gitlab_project" "this" {
  id = var.id
}


resource "gitlab_project_cluster" "this" {
  project            = var.id
  name               = var.cluster_name
  enabled            = true
  managed            = true
  kubernetes_api_url = var.cluster_endpoint
  kubernetes_ca_cert = base64decode(var.cluster_ca_cert)
  kubernetes_token   = var.cluster_token
}


resource "gitlab_project_variable" "project_vars" {
  for_each = var.project_vars

  project = var.id
  key     = each.key
  value   = each.value
}


resource "gitlab_project_variable" "masked_vars" {
  for_each = var.masked_vars

  project = var.id
  key     = each.key
  value   = each.value
}

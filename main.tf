locals {
  tags = merge(var.tags, { Project = var.gitlab_project_name })
}


provider "aws" {
  region = var.aws_region
}


resource "aws_key_pair" "default" {
  key_name   = var.aws_key_name
  public_key = file(var.aws_public_key_path)
  tags       = local.tags
}


resource "gitlab_project" "infrastructure_repository" {
  name = "${var.gitlab_project_name}-infrastructure"

  visibility_level = var.gitlab_project_public ? "public" : "private"
}


resource "gitlab_project" "project_repository" {
  name = var.gitlab_project_name

  visibility_level = var.gitlab_infrustructure_project_public ? "public" : "private"
}

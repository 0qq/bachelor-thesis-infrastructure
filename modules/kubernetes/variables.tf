# modules/kubernetes/variables.tf

variable "cluster_name" {}
variable "cluster_endpoint" {}
variable "cluster_ca_cert" {}
variable "cluster_node_group" {}

variable "ecr_url" {}
variable "ecr_username" {}
variable "ecr_password" {
  sensitive = true
}

variable "runner_name" {}
variable "gitlab_registration_token" {
  sensitive = true
}

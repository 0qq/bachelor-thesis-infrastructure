variable "id" {}
variable "cluster_name" {}
variable "cluster_endpoint" {}
variable "cluster_ca_cert" {
  sensitive = true
}
variable "cluster_token" {}

variable "project_vars" {
  type    = map(any)
  default = {}
}


variable "masked_vars" {
  type    = map(any)
  default = {}
}

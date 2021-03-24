variable "subnet_ids" {
  type = list(any)
}


variable "cluster_name" {}
variable "public_key_path" {}
variable "instance_types" {}
variable "desired_size" {}
variable "max_size" {}
variable "min_size" {}
variable "tags" {
  type    = map(any)
  default = {}
}

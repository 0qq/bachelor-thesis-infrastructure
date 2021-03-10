variable "tags" {
  description = "Common tags for all resources"
  type        = map(any)
  default     = {}
}


variable "project" {
  description = "Name of the project"
  type        = string
}


variable "remote_backend" {
  description = "Enable remote backend to store terraform state files"
  type        = bool
  default     = true
}


variable "master_instance_type" {
  description = "ec2 instance type to use for the master node. Must have least 2GB of RAM and 2 CPU"
  type        = string
  default     = "t3.micro"
}


variable "worker_instance_type" {
  description = "ec2 instance type to use for worker nodes. Must have at least 2GB of RAM and 2 CPU"
  type        = string
  default     = "t3.micro"
}


variable "worker_count" {
  description = "Number of k8s worker nodes"
  type        = number
}


variable "aws_region" {
  description = "AWS region to launch infrastructure"
  type        = string
}


variable "key_name" {
  default = "deployer"
}


variable "public_key_path" {
  description = "Path to public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}


variable "private_key_path" {
  type        = string
  description = "Path to private key"
  default     = "~/.ssh/id_rsa"
}


variable "kubeconfig_name" {
  type        = string
  description = "Local path for kubeconfig file"
  default     = "kube-config.yml"
}

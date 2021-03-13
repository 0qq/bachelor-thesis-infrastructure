variable "aws_region" {
  description = "AWS region to launch infrastructure"
  type        = string
}


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


# ==========
# KUBERNETES
# ==========
variable "k8s_master_instance_type" {
  description = "ec2 instance type to use for the master node. Must have least 2GB of RAM and 2 CPU"
  type        = string
  default     = "t3.micro"
}


variable "k8s_worker_instance_type" {
  description = "ec2 instance type to use for worker nodes. Must have at least 2GB of RAM and 2 CPU"
  type        = string
  default     = "t3.micro"
}


variable "k8s_worker_count" {
  description = "Number of k8s worker nodes"
  type        = number
  default     = 3
}


variable "kubeconfig_path" {
  type        = string
  description = "Local path for kubeconfig file"
  default     = "kube-config.yml"
}


# ==========
# Jenkins
# ==========
variable "jenkins_master_instance_type" {
  description = "ec2 instance type to use for jenkins master node"
  type        = string
  default     = "t3.micro"
}


variable "jenkins_worker_instance_type" {
  description = "ec2 instance type to use for jenkins worker nodes"
  type        = string
  default     = "t3.micro"
}


# ==========
# KEYS
# ==========
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

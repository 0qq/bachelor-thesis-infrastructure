variable "enable_terraform_remote_backend" {
  description = "Enable remote backend to store terraform state files"
  type        = bool
  default     = true
}


variable "backend_name" {
  description = "Name of the file for terraform backend"
  type        = string
  default     = "backend.tf"
}


# ==========
# AWS
# ==========
variable "container_registry_name" {
  description = "Name of container image registry"
  type        = string
}


variable "aws_public_key_path" {
  description = "Path to public key for AWS key pair"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}


variable "aws_region" {
  description = "AWS region to launch infrastructure"
  type        = string
}


variable "availability_zones" {
  description = "Availability zones to launch infrastructure"
  type        = list(string)
}


# ==========
# AWS/EKS
# ==========
variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}


variable "cluster_instance_types" {
  description = "List of instance types associated with the EKS Node Group"
  type        = list(string)
  default     = ["t3.medium"]
}


variable "cluster_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
}


variable "cluster_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
}


variable "cluster_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
}


variable "tags" {
  description = "Common tags for all AWS resources"
  type        = map(any)
  default     = {}
}


# ==========
# GitLab
# ==========
variable "gitlab_project_id" {
  description = "The integer that uniquely identifies the project within the gitlab"
  type        = number
}


variable "gitlab_runner_name" {
  description = "Name of all gitlab-runner api objects of Kubernetes"
  type        = string
  default     = "dev"
}

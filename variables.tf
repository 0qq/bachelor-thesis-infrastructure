variable "remote_backend" {
  description = "Enable remote backend to store terraform state files"
  type        = bool
  default     = true
}


# ==========
# AWS
# ==========
variable "aws_key_name" {
  default = "deployer"
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


variable "availability_zone_1" {
  description = "Availability zone to launch infrastructure"
  type        = string
}


variable "availability_zone_2" {
  description = "Second availability zone to launch infrastructure"
  type        = string
}


variable "tags" {
  description = "Common tags for all resources"
  type        = map(any)
  default     = {}
}


# ==========
# GitLab
# ==========
variable "gitlab_project_name" {
  description = "Name of the project"
  type        = string
}


variable "gitlab_project_public" {
  description = "Visibility of the project repository"
  type        = bool
  default     = false
}


variable "gitlab_infrustructure_project_public" {
  description = "Visibility of the infrastructure project repository"
  type        = bool
  default     = false
}

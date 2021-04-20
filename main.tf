# main.tf

locals {
  tags = var.tags
}


terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.36.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.1.0"
    }
  }
}


provider "aws" {
  region = var.aws_region
}


module "backend" {
  source     = "./modules/terraform/backend"
  filename   = var.backend_name
  aws_region = var.aws_region
  enable     = var.enable_terraform_remote_backend

  tags = local.tags
}


module "vpc" {
  source             = "./modules/aws/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  subnet_azs         = var.availability_zones
  cluster_name       = var.cluster_name

  tags = local.tags
}


module "eks" {
  source       = "./modules/aws/eks"
  cluster_name = var.cluster_name
  subnet_ids   = module.vpc.subnet_ids

  instance_types = var.cluster_instance_types
  desired_size   = var.cluster_desired_size
  max_size       = var.cluster_max_size
  min_size       = var.cluster_min_size

  public_key_path = var.aws_public_key_path

  tags = local.tags
}


module "kubernetes" {
  source             = "./modules/kubernetes"
  cluster_name       = var.cluster_name
  cluster_endpoint   = module.eks.endpoint
  cluster_ca_cert    = module.eks.ca_cert
  cluster_node_group = [module.eks.node_group]
  ecr_url            = module.container_registry.url
  ecr_username       = module.container_registry.username
  ecr_password       = module.container_registry.password

  gitlab_registration_token = module.project_repo.token
  runner_name               = var.gitlab_runner_name
}


module "container_registry" {
  source          = "./modules/aws/ecr"
  repository_name = var.container_registry_name

  tags = local.tags
}


module "project_repo" {
  source = "./modules/gitlab/project"
  id     = var.gitlab_project_id

  cluster_name     = var.cluster_name
  cluster_endpoint = module.eks.endpoint
  cluster_ca_cert  = module.eks.ca_cert
  cluster_token    = module.eks.token

  project_vars = {
    "REGISTRY_USER"  = module.container_registry.username,
    "REGISTRY_IMAGE" = module.container_registry.url,
    "IMAGE"          = var.container_registry_name,
  }
  masked_vars = {
    "REGISTRY_PASSWORD" = module.container_registry.password,
  }
}

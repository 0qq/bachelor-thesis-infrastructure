# modules/kubernetes/main.tf

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.1.0"
    }
  }
}


provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_cert)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command     = "aws"
  }
}


resource "kubernetes_secret" "docker_config" {
  metadata {
    name = "docker-cfg"
  }

  data = {
    ".dockerconfigjson" = <<-DOCKER
    {
      "auths": {
        "${var.ecr_url}": {
          "auth": "${base64encode("${var.ecr_username}:${var.ecr_password}")}"
        }
      }
    }
    DOCKER
  }

  type = "kubernetes.io/dockerconfigjson"
}



resource "kubernetes_namespace" "gitlab" {
  metadata {
    name = "gitlab"
  }
}

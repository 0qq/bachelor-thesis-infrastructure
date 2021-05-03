# modules/kubernetes/helm.tf

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_ca_cert)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}


resource "helm_release" "runner" {
  name       = var.runner_name
  repository = "https://charts.gitlab.io"
  chart      = "gitlab-runner"
  version    = "0.27.0"
  namespace  = kubernetes_namespace.gitlab.metadata[0].name

  values = [
    <<-EOF
    gitlabUrl: https://gitlab.com/
    runnerRegistrationToken: "${var.gitlab_registration_token}"
    unregisterRunners: true
    rbac:
      create: true
      rules:
        - resources: ["pods", "secrets"]
          verbs: ["get", "list", "watch", "create", "patch", "delete"]
        - apiGroups: [""]
          resources: ["pods/exec"]
          verbs: ["create", "patch", "delete"]
    runners:
      config: |
        [[runners]]
            environment = ["FF_GITLAB_REGISTRY_HELPER_IMAGE=1"]
          [runners.kubernetes]
            service_account = "${var.runner_name}-gitlab-runner"
            image = "ubuntu:20.04"
          [[runners.kubernetes.volumes.host_path]]
            name = "docker-socket"
            mount_path = "/var/run/docker.sock"
            host_path = "/var/run/docker.sock"
    EOF
  ]

  depends_on = [var.cluster_node_group]
}


resource "helm_release" "load-balancer-controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.1.6"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = var.cluster_name
    type  = "string"
  }

  depends_on = [var.cluster_node_group]
}
